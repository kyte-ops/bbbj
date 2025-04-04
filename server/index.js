const express = require('express');
const cors = require('cors');
const path = require('path');
const { getVideoLessons } = require('./data/videoLessons');

// Create Express app
const app = express();

// Define port (default to 3000)
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Serve a simple HTML page with a link to the Flutter app
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Learning App</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
          text-align: center;
        }
        .button {
          display: inline-block;
          background-color: #4CAF50;
          color: white;
          padding: 14px 20px;
          margin: 20px 0;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          font-size: 16px;
          text-decoration: none;
        }
        .button:hover {
          background-color: #45a049;
        }
        .info {
          margin: 20px 0;
          padding: 15px;
          background-color: #f8f9fa;
          border-radius: 5px;
          text-align: left;
        }
      </style>
    </head>
    <body>
      <h1>Flutter Learning App</h1>
      <p>This is a learning application with three tabs: Home, Study, and Profile.</p>
      <p>The Study tab features a calendar where you can select dates to view video lessons.</p>
      
      <a href="http://0.0.0.0:5000" class="button">Launch Flutter App</a>
      
      <div class="info">
        <h3>App Features:</h3>
        <ul>
          <li>Three-tab navigation (Home, Study, Profile)</li>
          <li>Calendar-based video lesson selection</li>
          <li>Video player with custom controls</li>
          <li>User profile information</li>
        </ul>
      </div>
      
      <p>If the button above doesn't work, try accessing the app directly at: <a href="http://0.0.0.0:5000">http://0.0.0.0:5000</a></p>
    </body>
    </html>
  `);
});

// Routes
app.get('/api/videoLessons', (req, res) => {
  try {
    const date = req.query.date;
    
    if (!date) {
      return res.status(400).json({ error: 'Date parameter is required' });
    }
    
    const lessons = getVideoLessons(date);
    
    // Add date to each lesson
    const lessonsWithDate = lessons.map(lesson => ({
      ...lesson,
      date: date
    }));
    
    res.json(lessonsWithDate);
  } catch (error) {
    console.error('Error fetching video lessons:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Mark lesson as completed
app.post('/api/videoLessons/:lessonId/complete', (req, res) => {
  try {
    const { lessonId } = req.params;
    
    // In a real app, this would update a database
    console.log(`Marking lesson ${lessonId} as completed`);
    
    res.json({ success: true, message: `Lesson ${lessonId} marked as completed` });
  } catch (error) {
    console.error('Error completing lesson:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// User profile endpoint
app.get('/api/profile', (req, res) => {
  try {
    // In a real app, this would fetch from a database based on authenticated user
    const userProfile = {
      id: 'user123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      joinedDate: '2023-01-15',
      completedLessons: 24,
      totalHoursStudied: 18.5,
      subjects: ['Mathematics', 'Science', 'History']
    };
    
    res.json(userProfile);
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
});
