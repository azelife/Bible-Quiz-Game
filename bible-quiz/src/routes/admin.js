/**
 * Admin Routes - Question Import/Management
 * FIXED: Proper CSV parsing with quote handling
 */

import { jsonResponse, errorResponse } from '../utils/response';

export async function handleAdmin(request, env, session) {
  const url = new URL(request.url);
  const path = url.pathname;
  const gameId = session.game_instance_id;

  // POST /api/admin/import/upload
  if (path === '/api/admin/import/upload' && request.method === 'POST') {
    return await uploadQuestions(request, env, gameId);
  }

  // GET /api/admin/questions/list
  if (path === '/api/admin/questions/list' && request.method === 'GET') {
    return await listQuestions(env, gameId);
  }

  // DELETE /api/admin/questions/delete
  if (path === '/api/admin/questions/delete' && request.method === 'DELETE') {
    const { question_type, question_number } = await request.json();
    return await deleteQuestion(env, gameId, question_type, question_number);
  }

  return errorResponse('Admin route not found', 404);
}

/**
 * Parse CSV properly handling quoted fields with commas
 */
function parseCSVLine(line) {
  const result = [];
  let current = '';
  let inQuotes = false;
  
  for (let i = 0; i < line.length; i++) {
    const char = line[i];
    
    if (char === '"') {
      // Handle escaped quotes ("")
      if (inQuotes && line[i + 1] === '"') {
        current += '"';
        i++; // Skip next quote
      } else {
        // Toggle quote state
        inQuotes = !inQuotes;
      }
    } else if (char === ',' && !inQuotes) {
      // End of field
      result.push(current.trim());
      current = '';
    } else {
      current += char;
    }
  }
  
  // Add last field
  result.push(current.trim());
  
  return result;
}

/**
 * Upload questions from CSV
 */
async function uploadQuestions(request, env, gameId) {
  try {
    const formData = await request.formData();
    const file = formData.get('csv_file');

    if (!file) {
      return errorResponse('No file uploaded', 400);
    }

    const csvText = await file.text();
    const lines = csvText.split('\n').filter(line => line.trim());

    if (lines.length < 2) {
      return errorResponse('CSV must contain header and at least one row', 400);
    }

    // Parse headers using proper CSV parser
    const headers = parseCSVLine(lines[0]).map(h => h.trim());
    const requiredHeaders = ['question_type', 'question_number', 'question_text', 'answer'];
    
    // Validate headers
    const missingHeaders = requiredHeaders.filter(h => !headers.includes(h));
    if (missingHeaders.length > 0) {
      return errorResponse(`Missing required headers: ${missingHeaders.join(', ')}`, 400);
    }

    let imported = 0;
    let errors = [];

    for (let i = 1; i < lines.length; i++) {
      // Use proper CSV parser for each line
      const values = parseCSVLine(lines[i]);
      const row = {};
      
      headers.forEach((header, idx) => {
        row[header] = values[idx] || '';
      });

      // Validate required fields
      if (!row.question_type || !row.question_number || !row.question_text || !row.answer) {
        errors.push(`Row ${i + 1}: Missing required fields`);
        continue;
      }

      // Validate question type
      if (!['quiz', 'recitation', 'character'].includes(row.question_type)) {
        errors.push(`Row ${i + 1}: Invalid question type '${row.question_type}'`);
        continue;
      }

      // Parse question number
      const questionNumber = parseInt(row.question_number);
      if (isNaN(questionNumber) || questionNumber < 1) {
        errors.push(`Row ${i + 1}: Invalid question number`);
        continue;
      }

      try {
        // Insert or replace question
        await env.DB.prepare(`
          INSERT OR REPLACE INTO questions 
          (game_instance_id, question_type, question_number, question_text, answer, 
           hint_1, hint_2, hint_3, hint_4, points, bonus_points, bonus_hint_points)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
          gameId,
          row.question_type,
          questionNumber,
          row.question_text,
          row.answer,
          row.hint_1 || null,
          row.hint_2 || null,
          row.hint_3 || null,
          row.hint_4 || null,
          parseInt(row.points) || 5,
          parseInt(row.bonus_points) || 2,
          parseInt(row.bonus_hint_points) || 1
        ).run();

        imported++;
      } catch (dbError) {
        errors.push(`Row ${i + 1}: Database error - ${dbError.message}`);
      }
    }

    return jsonResponse({
      success: true,
      imported,
      total_rows: lines.length - 1,
      errors: errors.length > 0 ? errors : null
    });

  } catch (error) {
    console.error('Import error:', error);
    return errorResponse('Failed to process CSV', 500);
  }
}

/**
 * List all questions for this game instance
 */
async function listQuestions(env, gameId) {
  const questions = await env.DB.prepare(`
    SELECT 
      question_type,
      question_number,
      question_text,
      answer,
      hint_1,
      hint_2,
      hint_3,
      hint_4,
      points,
      bonus_points,
      bonus_hint_points,
      imported_at
    FROM questions 
    WHERE game_instance_id = ?
    ORDER BY question_type, question_number
  `).bind(gameId).all();

  // Group by question type
  const grouped = {
    quiz: [],
    recitation: [],
    character: []
  };

  questions.results.forEach(q => {
    grouped[q.question_type].push(q);
  });

  return jsonResponse({
    success: true,
    questions: grouped,
    total: questions.results.length
  });
}

/**
 * Delete a specific question
 */
async function deleteQuestion(env, gameId, questionType, questionNumber) {
  if (!['quiz', 'recitation', 'character'].includes(questionType)) {
    return errorResponse('Invalid question type', 400);
  }

  const result = await env.DB.prepare(`
    DELETE FROM questions 
    WHERE game_instance_id = ? 
      AND question_type = ? 
      AND question_number = ?
  `).bind(gameId, questionType, questionNumber).run();

  if (result.changes === 0) {
    return errorResponse('Question not found', 404);
  }

  return jsonResponse({
    success: true,
    message: 'Question deleted successfully'
  });
}