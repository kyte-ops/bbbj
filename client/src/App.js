import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import Navigation from './components/Navigation';
import Home from './components/Home';
import Study from './components/Study';
import Profile from './components/Profile';
import './App.css';

function App() {
  return (
    <div className="App min-h-screen bg-gray-100">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold text-center mb-8">Learning Platform</h1>
        
        {/* Main content */}
        <div className="bg-white rounded-lg shadow-md p-6 mb-20">
          <Routes>
            <Route path="/home" element={<Home />} />
            <Route path="/study" element={<Study />} />
            <Route path="/profile" element={<Profile />} />
            <Route path="*" element={<Navigate to="/study" replace />} />
          </Routes>
        </div>
        
        {/* Navigation bar at the bottom */}
        <Navigation />
      </div>
    </div>
  );
}

export default App;
