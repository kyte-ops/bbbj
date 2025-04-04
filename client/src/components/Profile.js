import React from 'react';
import { FaUser, FaEnvelope, FaGraduationCap, FaClock, FaCalendarAlt } from 'react-icons/fa';

function Profile() {
  // Sample user data (in a real app, this would come from authentication/API)
  const user = {
    name: 'John Doe',
    email: 'john.doe@example.com',
    joinedDate: '2023-01-15',
    completedLessons: 24,
    totalHoursStudied: 18.5,
    subjects: ['Mathematics', 'Science', 'History']
  };

  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Your Profile</h2>
      
      <div className="flex flex-col md:flex-row gap-6">
        {/* Profile Information */}
        <div className="md:w-1/3">
          <div className="bg-gray-100 rounded-full w-32 h-32 flex items-center justify-center mx-auto md:mx-0 mb-4">
            <FaUser className="text-gray-500 text-5xl" />
          </div>
          
          <div className="space-y-3">
            <div className="flex items-center">
              <FaUser className="text-blue-600 mr-2" />
              <span className="font-medium">{user.name}</span>
            </div>
            <div className="flex items-center">
              <FaEnvelope className="text-blue-600 mr-2" />
              <span>{user.email}</span>
            </div>
            <div className="flex items-center">
              <FaCalendarAlt className="text-blue-600 mr-2" />
              <span>Joined: {new Date(user.joinedDate).toLocaleDateString()}</span>
            </div>
          </div>
        </div>
        
        {/* Learning Statistics */}
        <div className="md:w-2/3">
          <h3 className="text-xl font-semibold mb-4">Learning Statistics</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
            <div className="bg-blue-50 p-4 rounded-lg border border-blue-100">
              <div className="flex items-center mb-2">
                <FaGraduationCap className="text-blue-600 mr-2" />
                <h4 className="font-medium">Completed Lessons</h4>
              </div>
              <p className="text-2xl font-bold text-blue-700">{user.completedLessons}</p>
            </div>
            
            <div className="bg-green-50 p-4 rounded-lg border border-green-100">
              <div className="flex items-center mb-2">
                <FaClock className="text-green-600 mr-2" />
                <h4 className="font-medium">Hours Studied</h4>
              </div>
              <p className="text-2xl font-bold text-green-700">{user.totalHoursStudied}</p>
            </div>
          </div>
          
          <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
            <h4 className="font-medium mb-2">Your Subjects</h4>
            <div className="flex flex-wrap gap-2">
              {user.subjects.map((subject, index) => (
                <span 
                  key={index} 
                  className="bg-white px-3 py-1 rounded-full text-sm border border-gray-200"
                >
                  {subject}
                </span>
              ))}
            </div>
          </div>
        </div>
      </div>
      
      {/* Account Settings */}
      <div className="mt-8">
        <h3 className="text-xl font-semibold mb-4">Account Settings</h3>
        
        <div className="space-y-4">
          <button className="w-full md:w-auto px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
            Edit Profile
          </button>
          
          <button className="w-full md:w-auto px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors ml-0 md:ml-2">
            Change Password
          </button>
        </div>
      </div>
    </div>
  );
}

export default Profile;
