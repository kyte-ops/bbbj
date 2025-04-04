import React from 'react';
import { Link } from 'react-router-dom';
import { FaCalendarCheck, FaTrophy, FaBookOpen, FaChartLine } from 'react-icons/fa';

function Home() {
  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Welcome to Your Learning Journey</h2>
      
      <div className="mb-8">
        <p className="text-gray-700 mb-4">
          Track your progress, access your daily lessons, and improve your skills with our
          comprehensive learning platform.
        </p>
        
        <Link 
          to="/study" 
          className="inline-block bg-blue-600 text-white px-6 py-2 rounded-lg font-medium hover:bg-blue-700 transition-colors"
        >
          Go to Today's Lessons
        </Link>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
        <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
          <div className="flex items-center mb-2">
            <FaCalendarCheck className="text-blue-600 mr-2" />
            <h3 className="font-semibold">Daily Schedule</h3>
          </div>
          <p className="text-sm text-gray-600">
            Access your personalized learning schedule for consistent progress.
          </p>
        </div>
        
        <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
          <div className="flex items-center mb-2">
            <FaTrophy className="text-blue-600 mr-2" />
            <h3 className="font-semibold">Achievements</h3>
          </div>
          <p className="text-sm text-gray-600">
            Track your completed lessons and unlock achievements.
          </p>
        </div>
        
        <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
          <div className="flex items-center mb-2">
            <FaBookOpen className="text-blue-600 mr-2" />
            <h3 className="font-semibold">Learning Resources</h3>
          </div>
          <p className="text-sm text-gray-600">
            Access additional materials to supplement your video lessons.
          </p>
        </div>
        
        <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
          <div className="flex items-center mb-2">
            <FaChartLine className="text-blue-600 mr-2" />
            <h3 className="font-semibold">Progress Tracking</h3>
          </div>
          <p className="text-sm text-gray-600">
            Visualize your learning journey and identify areas for improvement.
          </p>
        </div>
      </div>
      
      <div className="text-center text-gray-500 text-sm">
        <p>Need help? Contact our support team.</p>
      </div>
    </div>
  );
}

export default Home;
