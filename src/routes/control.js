/**
 * Control Dashboard API Routes - COMPLETE UPDATED VERSION
 */

import { jsonResponse, errorResponse } from '../utils/response.js';

export async function handleControl(request, env, session) {
  const url = new URL(request.url);
  const path = url.pathname;
  const gameId = session.game_instance_id;

  // GET /api/control/state
  if (path === '/api/control/state' && request.method === 'GET') {
    return await getControlState(env, gameId);
  }

  // POST /api/control/game-type/select
  if (path === '/api/control/game-type/select' && request.method === 'POST') {
    const { question_type } = await request.json();
    return await selectGameType(env, gameId, question_type);
  }

  // POST /api/control/team/select
  if (path === '/api/control/team/select' && request.method === 'POST') {
    const { team } = await request.json();
    return await selectTeam(env, gameId, team);
  }

  // POST /api/control/members/update
  if (path === '/api/control/members/update' && request.method === 'POST') {
    const body = await request.json();
    return await updateMembers(env, gameId, body);
  }

  // POST /api/control/score-display/toggle
  if (path === '/api/control/score-display/toggle' && request.method === 'POST') {
    const { show_breakdown } = await request.json();
    return await toggleScoreDisplay(env, gameId, show_breakdown);
  }

  // POST /api/control/question/load
  if (path === '/api/control/question/load' && request.method === 'POST') {
    const { question_number } = await request.json();
    return await loadQuestion(env, gameId, question_number);
  }

  // POST /api/control/question/clear
  if (path === '/api/control/question/clear' && request.method === 'POST') {
    return await clearQuestion(env, gameId);
  }

  // POST /api/control/hint/request
  if (path === '/api/control/hint/request' && request.method === 'POST') {
    return await requestHint(env, gameId);
  }

  // POST /api/control/hint/reveal
  if (path === '/api/control/hint/reveal' && request.method === 'POST') {
    const { hint_number } = await request.json();
    return await revealHint(env, gameId, hint_number);
  }

  // POST /api/control/timer/start
  if (path === '/api/control/timer/start' && request.method === 'POST') {
    const { is_bonus } = await request.json();
    return await startTimer(env, gameId, is_bonus);
  }

  // POST /api/control/timer/reset
  if (path === '/api/control/timer/reset' && request.method === 'POST') {
    return await resetTimer(env, gameId);
  }

  // POST /api/control/answer/submit
  if (path === '/api/control/answer/submit' && request.method === 'POST') {
    const body = await request.json();
    return await submitAnswer(env, gameId, body);
  }

  // POST /api/control/question/skip
  if (path === '/api/control/question/skip' && request.method === 'POST') {
    return await skipQuestion(env, gameId);
  }

  // POST /api/control/action/undo
  if (path === '/api/control/action/undo' && request.method === 'POST') {
    return await undoAction(env, gameId);
  }

  // POST /api/control/game/end
  if (path === '/api/control/game/end' && request.method === 'POST') {
    return await endGame(env, gameId);
  }

  // POST /api/control/game/reset
  if (path === '/api/control/game/reset' && request.method === 'POST') {
    return await resetGame(env, gameId);
  }

  // POST /api/control/theme/toggle
  if (path === '/api/control/theme/toggle' && request.method === 'POST') {
    return await toggleTheme(env, gameId);
  }

  // POST /api/control/state/save
  if (path === '/api/control/state/save' && request.method === 'POST') {
    return await saveState(env, gameId);
  }

  return errorResponse('Control route not found', 404);
}

// ============================================================================
// ROUTE HANDLERS
// ============================================================================

async function getControlState(env, gameId) {
  const state = await env.DB.prepare(`
    SELECT * FROM game_state WHERE game_instance_id = ?
  `).bind(gameId).first();

  if (!state) {
    return errorResponse('Game state not found', 404);
  }

  // Get current question if loaded
  let currentQuestion = null;
  if (state.current_question_type && state.current_question_number) {
    currentQuestion = await env.DB.prepare(`
      SELECT * FROM questions 
      WHERE game_instance_id = ? 
        AND question_type = ? 
        AND question_number = ?
    `).bind(gameId, state.current_question_type, state.current_question_number).first();
  }

  // Get team members
  const members = await env.DB.prepare(`
    SELECT * FROM team_members 
    WHERE game_instance_id = ? 
    ORDER BY team, member_number
  `).bind(gameId).all();

  return jsonResponse({
    success: true,
    state,
    current_question: currentQuestion,
    team_members: members.results
  });
}

async function selectGameType(env, gameId, questionType) {
  if (!['quiz', 'recitation', 'character'].includes(questionType)) {
    return errorResponse('Invalid question type', 400);
  }

  await env.DB.prepare(`
    UPDATE game_state 
    SET current_question_type = ?, updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(questionType, gameId).run();

  return jsonResponse({ success: true, question_type: questionType });
}

async function selectTeam(env, gameId, team) {
  if (!['A', 'B'].includes(team)) {
    return errorResponse('Invalid team', 400);
  }

  await env.DB.prepare(`
    UPDATE game_state 
    SET active_team = ?, updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(team, gameId).run();

  return jsonResponse({ success: true, active_team: team });
}

async function updateMembers(env, gameId, body) {
  const { team, members } = body;
  
  if (!['A', 'B'].includes(team) || !Array.isArray(members)) {
    return errorResponse('Invalid request', 400);
  }

  const updates = members.map(m => 
    env.DB.prepare(`
      UPDATE team_members 
      SET member_name = ?, is_visible = ?
      WHERE game_instance_id = ? AND team = ? AND member_number = ?
    `).bind(m.name || '', m.visible ? 1 : 0, gameId, team, m.number).run()
  );

  await Promise.all(updates);

  return jsonResponse({ success: true });
}

async function toggleScoreDisplay(env, gameId, showBreakdown) {
  await env.DB.prepare(`
    UPDATE game_state 
    SET show_score_breakdown = ?, 
        show_aggregate_only = ?,
        updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(showBreakdown ? 1 : 0, showBreakdown ? 0 : 1, gameId).run();

  return jsonResponse({ success: true, show_breakdown: showBreakdown });
}

async function loadQuestion(env, gameId, questionNumber) {
  const state = await env.DB.prepare(`
    SELECT current_question_type FROM game_state WHERE game_instance_id = ?
  `).bind(gameId).first();

  if (!state?.current_question_type) {
    return errorResponse('No question type selected', 400);
  }

  const question = await env.DB.prepare(`
    SELECT * FROM questions 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, state.current_question_type, questionNumber).first();

  if (!question) {
    return errorResponse('Question not found', 404);
  }

  // Check if already answered in this session
  const sessionAnswer = await env.DB.prepare(`
    SELECT team FROM session_answers 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, state.current_question_type, questionNumber).first();

  // Reset question state (but keep question_type!)
  await env.DB.prepare(`
    UPDATE game_state 
    SET current_question_number = ?,
        hints_shown = 0,
        hints_requested = 0,
        question_answered = 0,
        answer_visible = 0,
        is_bonus_round = 0,
        timer_started_at = NULL,
        updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(questionNumber, gameId).run();

  return jsonResponse({
    success: true,
    question,
    already_answered: !!sessionAnswer,
    answered_by_team: sessionAnswer?.team || null
  });
}

async function clearQuestion(env, gameId) {
  try {
    await env.DB.prepare(`
      UPDATE game_state 
      SET current_question_number = NULL,
          hints_shown = 0,
          hints_requested = 0,
          question_answered = 0,
          answer_visible = 0,
          is_bonus_round = 0,
          timer_started_at = NULL,
          updated_at = datetime('now')
      WHERE game_instance_id = ?
    `).bind(gameId).run();

    return jsonResponse({ success: true, message: 'Question cleared (type preserved)' });
  } catch (error) {
    return errorResponse(`Failed to clear question: ${error.message}`, 500);
  }
}

async function requestHint(env, gameId) {
  const state = await env.DB.prepare(`
    SELECT hints_requested, current_question_type, current_question_number 
    FROM game_state WHERE game_instance_id = ?
  `).bind(gameId).first();

  if (!state?.current_question_type || !state.current_question_number) {
    return errorResponse('No question loaded', 400);
  }

  // Get question to check available hints
  const question = await env.DB.prepare(`
    SELECT hint_1, hint_2, hint_3, hint_4 FROM questions 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, state.current_question_type, state.current_question_number).first();

  const availableHints = [question.hint_1, question.hint_2, question.hint_3, question.hint_4].filter(h => h).length;
  
  if (state.hints_requested >= availableHints) {
    return errorResponse('No more hints available', 400);
  }

  const newRequested = state.hints_requested + 1;

  await env.DB.prepare(`
    UPDATE game_state 
    SET hints_requested = ?, updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(newRequested, gameId).run();

  return jsonResponse({ 
    success: true, 
    hints_requested: newRequested,
    available_hints: availableHints
  });
}

async function revealHint(env, gameId, hintNumber) {
  if (hintNumber < 1 || hintNumber > 4) {
    return errorResponse('Invalid hint number', 400);
  }

  const state = await env.DB.prepare(`
    SELECT hints_shown, current_question_type, current_question_number 
    FROM game_state WHERE game_instance_id = ?
  `).bind(gameId).first();

  if (!state?.current_question_type || !state.current_question_number) {
    return errorResponse('No question loaded', 400);
  }

  // Get question to check available hints
  const question = await env.DB.prepare(`
    SELECT hint_1, hint_2, hint_3, hint_4 FROM questions 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, state.current_question_type, state.current_question_number).first();

  const availableHints = [question.hint_1, question.hint_2, question.hint_3, question.hint_4].filter(h => h).length;
  
  if (hintNumber > availableHints) {
    return errorResponse('Hint does not exist', 400);
  }

  await env.DB.prepare(`
    UPDATE game_state 
    SET hints_shown = ?, updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(hintNumber, gameId).run();

  return jsonResponse({ 
    success: true, 
    hints_shown: hintNumber,
    available_hints: availableHints
  });
}

async function startTimer(env, gameId, isBonus) {
  const duration = isBonus ? 30 : 60;

  await env.DB.prepare(`
    UPDATE game_state 
    SET timer_started_at = datetime('now'),
        timer_duration = ?,
        updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(duration, gameId).run();

  return jsonResponse({ success: true, duration });
}

async function resetTimer(env, gameId) {
  await env.DB.prepare(`
    UPDATE game_state 
    SET timer_started_at = NULL, updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(gameId).run();

  return jsonResponse({ success: true });
}

async function submitAnswer(env, gameId, body) {
  const { is_correct, is_bonus } = body;

  const state = await env.DB.prepare(`
    SELECT * FROM game_state WHERE game_instance_id = ?
  `).bind(gameId).first();

  if (!state?.current_question_type || !state.current_question_number || !state.active_team) {
    return errorResponse('Invalid game state', 400);
  }

  // Check if this question has already been answered in this session
  const sessionAnswer = await env.DB.prepare(`
    SELECT id, team FROM session_answers 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, state.current_question_type, state.current_question_number).first();

  if (sessionAnswer) {
    return errorResponse(`This question has already been answered by Team ${sessionAnswer.team} in this session`, 400);
  }

  const question = await env.DB.prepare(`
    SELECT * FROM questions 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, state.current_question_type, state.current_question_number).first();

  // Calculate points
  let points = 0;
  if (is_correct) {
    points = is_bonus ? question.bonus_points : question.points;
    points -= state.hints_shown * question.bonus_hint_points;
    points = Math.max(0, points);
  }

  // Get current score for undo
  const scoreField = `team_${state.active_team.toLowerCase()}_${state.current_question_type}_score`;
  const currentScore = state[scoreField] || 0;

  // Update score
  await env.DB.prepare(`
    UPDATE game_state 
    SET ${scoreField} = ${scoreField} + ?,
        question_answered = 1,
        answer_visible = 1,
        updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(points, gameId).run();

  // Record in session_answers to prevent duplicate scoring
  await env.DB.prepare(`
    INSERT INTO session_answers 
    (game_instance_id, question_type, question_number, team)
    VALUES (?, ?, ?, ?)
  `).bind(
    gameId,
    state.current_question_type,
    state.current_question_number,
    state.active_team
  ).run();

  // Log answer for history
  await env.DB.prepare(`
    INSERT INTO answer_log 
    (game_instance_id, question_type, question_number, team, is_bonus, is_correct, hints_used, points_awarded)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `).bind(
    gameId,
    state.current_question_type,
    state.current_question_number,
    state.active_team,
    is_bonus ? 1 : 0,
    is_correct ? 1 : 0,
    state.hints_shown,
    points
  ).run();

  // Save state for undo
  await env.DB.prepare(`
    INSERT INTO undo_history 
    (game_instance_id, action_type, previous_state)
    VALUES (?, ?, ?)
  `).bind(
    gameId,
    'submit_answer',
    JSON.stringify({
      question_type: state.current_question_type,
      question_number: state.current_question_number,
      team: state.active_team,
      score_field: scoreField,
      previous_score: currentScore,
      points_added: points
    })
  ).run();

  return jsonResponse({ success: true, points_awarded: points });
}

async function skipQuestion(env, gameId) {
  const state = await env.DB.prepare(`
    SELECT * FROM game_state WHERE game_instance_id = ?
  `).bind(gameId).first();

  const opposingTeam = state.active_team === 'A' ? 'B' : 'A';
  const question = await env.DB.prepare(`
    SELECT bonus_points FROM questions 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, state.current_question_type, state.current_question_number).first();

  // Get current score for undo
  const scoreField = `team_${opposingTeam.toLowerCase()}_${state.current_question_type}_score`;
  const currentScore = state[scoreField] || 0;

  // Award bonus points to opposing team
  await env.DB.prepare(`
    UPDATE game_state 
    SET ${scoreField} = ${scoreField} + ?,
        active_team = ?,
        question_answered = 1,
        updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(question.bonus_points, opposingTeam, gameId).run();

  // Record in session_answers
  await env.DB.prepare(`
    INSERT INTO session_answers 
    (game_instance_id, question_type, question_number, team)
    VALUES (?, ?, ?, ?)
  `).bind(
    gameId,
    state.current_question_type,
    state.current_question_number,
    opposingTeam
  ).run();

  // Log skip
  await env.DB.prepare(`
    INSERT INTO skip_log 
    (game_instance_id, question_type, question_number, skipped_by_team)
    VALUES (?, ?, ?, ?)
  `).bind(gameId, state.current_question_type, state.current_question_number, state.active_team).run();

  // Save state for undo
  await env.DB.prepare(`
    INSERT INTO undo_history 
    (game_instance_id, action_type, previous_state)
    VALUES (?, ?, ?)
  `).bind(
    gameId,
    'skip_question',
    JSON.stringify({
      question_type: state.current_question_type,
      question_number: state.current_question_number,
      skipped_by_team: state.active_team,
      awarded_to_team: opposingTeam,
      score_field: scoreField,
      previous_score: currentScore,
      points_added: question.bonus_points
    })
  ).run();

  return jsonResponse({ success: true, points_awarded: question.bonus_points });
}

async function undoAction(env, gameId) {
  // Get last undo record
  const lastUndo = await env.DB.prepare(`
    SELECT * FROM undo_history 
    WHERE game_instance_id = ? 
    ORDER BY created_at DESC 
    LIMIT 1
  `).bind(gameId).first();

  if (!lastUndo) {
    return errorResponse('No action to undo', 400);
  }

  const prevState = JSON.parse(lastUndo.previous_state);

  // Revert score
  if (prevState.score_field && prevState.previous_score !== undefined) {
    await env.DB.prepare(`
      UPDATE game_state 
      SET ${prevState.score_field} = ?,
          updated_at = datetime('now')
      WHERE game_instance_id = ?
    `).bind(prevState.previous_score, gameId).run();
  }

  // Remove from session_answers
  if (prevState.question_type && prevState.question_number) {
    await env.DB.prepare(`
      DELETE FROM session_answers 
      WHERE game_instance_id = ? 
        AND question_type = ? 
        AND question_number = ?
    `).bind(gameId, prevState.question_type, prevState.question_number).run();
  }

  // Delete undo record
  await env.DB.prepare(`
    DELETE FROM undo_history WHERE id = ?
  `).bind(lastUndo.id).run();

  return jsonResponse({ 
    success: true,
    undone_action: lastUndo.action_type,
    points_reverted: prevState.points_added || 0
  });
}

async function endGame(env, gameId) {
  await env.DB.prepare(`
    UPDATE game_state 
    SET game_ended = 1,
        show_score_breakdown = 1,
        updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(gameId).run();

  // Get final scores
  const state = await env.DB.prepare(`
    SELECT 
      team_a_quiz_score, team_a_recitation_score, team_a_character_score,
      team_b_quiz_score, team_b_recitation_score, team_b_character_score
    FROM game_state 
    WHERE game_instance_id = ?
  `).bind(gameId).first();

  const teamATotal = state.team_a_quiz_score + state.team_a_recitation_score + state.team_a_character_score;
  const teamBTotal = state.team_b_quiz_score + state.team_b_recitation_score + state.team_b_character_score;

  return jsonResponse({
    success: true,
    final_scores: {
      team_a: {
        total: teamATotal,
        quiz: state.team_a_quiz_score,
        recitation: state.team_a_recitation_score,
        character: state.team_a_character_score
      },
      team_b: {
        total: teamBTotal,
        quiz: state.team_b_quiz_score,
        recitation: state.team_b_recitation_score,
        character: state.team_b_character_score
      }
    }
  });
}

async function resetGame(env, gameId) {
  console.log('🔄 RESET GAME STARTED for gameId:', gameId);
  
  try {
    const gameExists = await env.DB.prepare(`
      SELECT game_instance_id FROM game_state WHERE game_instance_id = ?
    `).bind(gameId).first();
    
    if (!gameExists) {
      console.error('❌ Game not found');
      return errorResponse('Game not found', 404);
    }

    // Reset game_state
    await env.DB.prepare(`
      UPDATE game_state 
      SET 
        current_question_number = NULL,
        current_question_type = NULL,
        active_team = NULL,
        timer_started_at = NULL,
        timer_duration = 60,
        hints_requested = 0,
        hints_shown = 0,
        answer_visible = 0,
        question_answered = 0,
        is_bonus_round = 0,
        team_a_quiz_score = 0,
        team_a_recitation_score = 0,
        team_a_character_score = 0,
        team_b_quiz_score = 0,
        team_b_recitation_score = 0,
        team_b_character_score = 0,
        game_ended = 0,
        show_score_breakdown = 0,
        updated_at = datetime('now')
      WHERE game_instance_id = ?
    `).bind(gameId).run();

    // Clear all session data
    await env.DB.prepare('DELETE FROM session_answers WHERE game_instance_id = ?').bind(gameId).run();
    await env.DB.prepare('DELETE FROM answer_log WHERE game_instance_id = ?').bind(gameId).run();
    await env.DB.prepare('DELETE FROM skip_log WHERE game_instance_id = ?').bind(gameId).run();
    await env.DB.prepare('DELETE FROM undo_history WHERE game_instance_id = ?').bind(gameId).run();

    console.log('✅ RESET GAME COMPLETED');

    return jsonResponse({
      success: true,
      message: 'Game reset successfully'
    });

  } catch (error) {
    console.error('❌ RESET GAME FAILED:', error);
    return errorResponse(`Failed to reset game: ${error.message}`, 500);
  }
}

async function toggleTheme(env, gameId) {
  const state = await env.DB.prepare(`
    SELECT dark_mode FROM game_state WHERE game_instance_id = ?
  `).bind(gameId).first();

  const newMode = !state.dark_mode;

  await env.DB.prepare(`
    UPDATE game_state 
    SET dark_mode = ?, updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(newMode ? 1 : 0, gameId).run();

  return jsonResponse({ success: true, dark_mode: newMode });
}

async function saveState(env, gameId) {
  await env.DB.prepare(`
    UPDATE game_state 
    SET last_saved_at = datetime('now'), updated_at = datetime('now')
    WHERE game_instance_id = ?
  `).bind(gameId).run();

  return jsonResponse({ success: true, saved_at: new Date().toISOString() });
}