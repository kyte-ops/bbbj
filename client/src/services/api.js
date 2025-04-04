// Base URL for API requests
const API_BASE_URL = 'http://localhost:8000/api';

/**
 * Fetch video lessons for a specific date
 * @param {string} date - Date in YYYY-MM-DD format
 * @returns {Promise<Array>} - Array of video lesson objects
 */
export const fetchVideoLessons = async (date) => {
  try {
    const response = await fetch(`${API_BASE_URL}/videoLessons?date=${date}`);
    
    if (!response.ok) {
      throw new Error(`API error: ${response.status}`);
    }
    
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching video lessons:', error);
    throw error;
  }
};

/**
 * Fetch user profile data
 * @returns {Promise<Object>} - User profile object
 */
export const fetchUserProfile = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/user/profile`);
    
    if (!response.ok) {
      throw new Error(`API error: ${response.status}`);
    }
    
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error fetching user profile:', error);
    throw error;
  }
};
