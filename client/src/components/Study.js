import React, { useState, useEffect } from 'react';
import Calendar from 'react-calendar';
import 'react-calendar/dist/Calendar.css';
import VideoPlayer from './VideoPlayer';
import { fetchVideoLessons } from '../services/api';
import { format } from 'date-fns';
import { FaVideo, FaExclamationCircle } from 'react-icons/fa';

function Study() {
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [videoLessons, setVideoLessons] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedVideo, setSelectedVideo] = useState(null);

  // Fetch video lessons when the selected date changes
  useEffect(() => {
    const getVideoLessons = async () => {
      try {
        setLoading(true);
        const formattedDate = format(selectedDate, 'yyyy-MM-dd');
        const lessons = await fetchVideoLessons(formattedDate);
        setVideoLessons(lessons);
        setError(null);
      } catch (err) {
        console.error('Error fetching video lessons:', err);
        setError('Failed to load video lessons. Please try again later.');
        setVideoLessons([]);
      } finally {
        setLoading(false);
      }
    };

    getVideoLessons();
  }, [selectedDate]);

  // Handle date change from calendar
  const handleDateChange = (date) => {
    setSelectedDate(date);
    setSelectedVideo(null); // Reset selected video when date changes
  };

  // Handle selecting a video to play
  const handleSelectVideo = (video) => {
    setSelectedVideo(video);
  };

  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Study Calendar</h2>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Calendar Section */}
        <div className="mb-6">
          <h3 className="text-lg font-semibold mb-3">Select a Date</h3>
          <div className="calendar-container">
            <Calendar 
              onChange={handleDateChange} 
              value={selectedDate}
              className="rounded-lg border border-gray-200 w-full"
            />
          </div>
          <p className="mt-2 text-gray-600">
            Selected date: {format(selectedDate, 'MMMM d, yyyy')}
          </p>
        </div>
        
        {/* Video Lessons Section */}
        <div>
          <h3 className="text-lg font-semibold mb-3">
            Video Lessons for {format(selectedDate, 'MMMM d, yyyy')}
          </h3>
          
          {loading && (
            <div className="text-center py-8">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
              <p className="mt-2 text-gray-600">Loading lessons...</p>
            </div>
          )}
          
          {error && (
            <div className="bg-red-50 text-red-600 p-4 rounded-lg flex items-center">
              <FaExclamationCircle className="mr-2" />
              <p>{error}</p>
            </div>
          )}
          
          {!loading && !error && videoLessons.length === 0 && (
            <div className="bg-gray-50 p-6 rounded-lg border border-gray-200 text-center">
              <p className="text-gray-600">No video lessons available for this date.</p>
            </div>
          )}
          
          {!loading && !error && videoLessons.length > 0 && (
            <div className="space-y-4">
              {videoLessons.map((video) => (
                <div 
                  key={video.id}
                  className={`p-4 rounded-lg border cursor-pointer transition-all ${
                    selectedVideo && selectedVideo.id === video.id
                      ? 'bg-blue-50 border-blue-300'
                      : 'bg-white border-gray-200 hover:bg-gray-50'
                  }`}
                  onClick={() => handleSelectVideo(video)}
                >
                  <div className="flex items-center">
                    <div className="bg-blue-100 p-2 rounded-full mr-3">
                      <FaVideo className="text-blue-600" />
                    </div>
                    <div>
                      <h4 className="font-medium">{video.title}</h4>
                      <p className="text-sm text-gray-600">{video.duration} • {video.subject}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
      
      {/* Video Player Section */}
      {selectedVideo && (
        <div className="mt-8">
          <h3 className="text-lg font-semibold mb-3">{selectedVideo.title}</h3>
          <VideoPlayer url={selectedVideo.videoUrl} />
          <div className="mt-4 bg-gray-50 p-4 rounded-lg border border-gray-200">
            <h4 className="font-medium mb-2">Description</h4>
            <p className="text-gray-700">{selectedVideo.description}</p>
          </div>
        </div>
      )}
    </div>
  );
}

export default Study;
