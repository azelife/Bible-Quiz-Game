/**
 * Viewer Dashboard API Routes - UPDATED WITH TIMER SUPPORT
 */

import { jsonResponse, errorResponse } from '../utils/response.js';

export async function handleViewer(request, env, session) {
  const url = new URL(request.url);
  const path = url.pathname;
  const gameId = session.game_instance_id;

  // GET /api/viewer/state
  if (path === '/api/viewer/state' && request.method === 'GET') {
    return await getViewerState(env, gameId);
  }

  return errorResponse('Viewer route not found', 404);
}

/**
 * Get public game state for viewing dashboard
 * Returns only data that should be visible to viewers
 */
async function getViewerState(env, gameId) {
  console.log('🔍 [VIEWER] Fetching game state for gameId:', gameId);
  
  // Get game state
  const state = await env.DB.prepare(`
    SELECT 
      current_question_type,
      current_question_number,
      active_team,
      is_bonus_round,
      hints_shown,
      hints_requested,
      question_answered,
      answer_visible,
      team_a_quiz_score,
      team_a_recitation_score,
      team_a_character_score,
      team_b_quiz_score,
      team_b_recitation_score,
      team_b_character_score,
      show_score_breakdown,
      show_aggregate_only,
      game_ended,
      timer_started_at,
      timer_duration,
      dark_mode,
      updated_at
    FROM game_state 
    WHERE game_instance_id = ?
  `).bind(gameId).first();

  if (!state) {
    console.error('❌ [VIEWER] Game state not found for gameId:', gameId);
    return errorResponse('Game state not found', 404);
  }

  console.log('📊 [VIEWER] Game state retrieved:', {
    current_question_type: state.current_question_type,
    current_question_number: state.current_question_number,
    active_team: state.active_team,
    game_ended: state.game_ended,
    timer_started_at: state.timer_started_at,
    timer_duration: state.timer_duration
  });

  // Calculate timer remaining - CRITICAL for client-side countdown
  let timeRemaining = null;
  if (state.timer_started_at) {
    try {
      // Parse ISO 8601 datetime from SQLite
      const startTime = new Date(state.timer_started_at + 'Z').getTime(); // Add Z for UTC
      const now = Date.now();
      const elapsed = (now - startTime) / 1000; // Convert to seconds
      const remaining = state.timer_duration - elapsed;
      
      // Only send positive values, if timer expired send 0
      timeRemaining = Math.max(0, remaining);
      
      console.log('⏱️ [VIEWER] Timer calculation:', {
        startTime: state.timer_started_at,
        duration: state.timer_duration,
        elapsed: elapsed.toFixed(2),
        remaining: timeRemaining.toFixed(2)
      });
    } catch (error) {
      console.error('❌ [VIEWER] Timer calculation error:', error);
      timeRemaining = null;
    }
  } else {
    console.log('ℹ️ [VIEWER] No active timer');
  }

  // Get current question (only if both type AND number are set)
  let currentQuestion = null;
  const shouldFetchQuestion = state.current_question_type && 
                              state.current_question_number && 
                              state.current_question_type !== '' && 
                              state.current_question_number > 0;
  
  console.log('🔍 [VIEWER] Should fetch question?', shouldFetchQuestion);

  if (shouldFetchQuestion) {
    console.log('📖 [VIEWER] Fetching question:', {
      type: state.current_question_type,
      number: state.current_question_number
    });

    const question = await env.DB.prepare(`
      SELECT 
        question_type,
        question_number,
        question_text,
        hint_1,
        hint_2,
        hint_3,
        hint_4,
        answer
      FROM questions 
      WHERE game_instance_id = ? 
        AND question_type = ? 
        AND question_number = ?
    `).bind(gameId, state.current_question_type, state.current_question_number).first();

    if (question) {
      console.log('✅ [VIEWER] Question found:', {
        type: question.question_type,
        number: question.question_number
      });

      // Build hints array (only show revealed hints)
      const hints = [];
      if (state.hints_shown >= 1 && question.hint_1) hints.push(question.hint_1);
      if (state.hints_shown >= 2 && question.hint_2) hints.push(question.hint_2);
      if (state.hints_shown >= 3 && question.hint_3) hints.push(question.hint_3);
      if (state.hints_shown >= 4 && question.hint_4) hints.push(question.hint_4);

      // Add "requested" hints (not yet revealed)
      const requestedCount = state.hints_requested - state.hints_shown;
      for (let i = 0; i < requestedCount; i++) {
        hints.push({ requested: true, number: state.hints_shown + i + 1 });
      }

      console.log('💡 [VIEWER] Hints prepared:', {
        shown: state.hints_shown,
        requested: state.hints_requested,
        total_hints: hints.length
      });

      currentQuestion = {
        type: question.question_type,
        number: question.question_number,
        text: question.question_text,
        hints: hints,
        answer: state.answer_visible ? question.answer : null
      };
    } else {
      console.warn('⚠️ [VIEWER] Question not found in database');
    }
  } else {
    console.log('ℹ️ [VIEWER] No question to fetch');
  }

  // Get visible team members
  const members = await env.DB.prepare(`
    SELECT team, member_number, member_name
    FROM team_members 
    WHERE game_instance_id = ? 
      AND is_visible = 1 
      AND member_name IS NOT NULL 
      AND member_name != ''
    ORDER BY team, member_number
  `).bind(gameId).all();

  console.log('👥 [VIEWER] Team members found:', members.results?.length || 0);

  // Get scores based on current question type (only show relevant scores)
  let scores = {
    team_a: { quiz: 0, recitation: 0, character: 0, total: 0 },
    team_b: { quiz: 0, recitation: 0, character: 0, total: 0 }
  };

  if (state.current_question_type) {
    // Only populate the scores for the active question type
    scores.team_a[state.current_question_type] = state[`team_a_${state.current_question_type}_score`] || 0;
    scores.team_b[state.current_question_type] = state[`team_b_${state.current_question_type}_score`] || 0;
  }

  // Calculate totals for game end screen
  if (state.game_ended) {
    scores.team_a.quiz = state.team_a_quiz_score || 0;
    scores.team_a.recitation = state.team_a_recitation_score || 0;
    scores.team_a.character = state.team_a_character_score || 0;
    scores.team_b.quiz = state.team_b_quiz_score || 0;
    scores.team_b.recitation = state.team_b_recitation_score || 0;
    scores.team_b.character = state.team_b_character_score || 0;
    scores.team_a.total = scores.team_a.quiz + scores.team_a.recitation + scores.team_a.character;
    scores.team_b.total = scores.team_b.quiz + scores.team_b.recitation + scores.team_b.character;
  }

  console.log('🏆 [VIEWER] Scores prepared for type:', state.current_question_type);

  const response = {
    success: true,
    game_state: {
      active_team: state.active_team,
      current_question_type: state.current_question_type,
      current_question_number: state.current_question_number,
      is_bonus_round: state.is_bonus_round,
      game_ended: state.game_ended,
      dark_mode: state.dark_mode,
      show_score_breakdown: state.show_score_breakdown,
      timer_remaining: timeRemaining  // Send calculated remaining time for client countdown
    },
    current_question: currentQuestion,
    scores: scores,
    team_members: members.results || []
  };

  console.log('📤 [VIEWER] Sending response with timer:', timeRemaining !== null ? `${timeRemaining.toFixed(2)}s` : 'null');

  return jsonResponse(response);
}