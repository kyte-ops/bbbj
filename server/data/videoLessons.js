// In-memory data store for video lessons
// In a real application, this would be replaced with a database

// Generate random lessons based on the date to simulate different content each day
const getVideoLessons = (dateString) => {
  // Use the date string to seed "random" but consistent lessons for each date
  const dateObj = new Date(dateString);
  const dateSeed = dateObj.getDate() + (dateObj.getMonth() * 31);
  
  // Lessons library (limited set for demo purposes)
  const lessonLibrary = [
    {
      id: 'math-101',
      title: 'Introduction to Algebra',
      subject: 'Mathematics',
      description: 'Learn the basics of algebraic expressions and equations, including variables, constants, and basic operations.',
      duration: '15 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    },
    {
      id: 'math-102',
      title: 'Quadratic Equations',
      subject: 'Mathematics',
      description: 'Understanding the quadratic formula and how to solve quadratic equations step by step.',
      duration: '20 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    },
    {
      id: 'science-101',
      title: 'Introduction to Chemistry',
      subject: 'Science',
      description: 'Learn about atoms, molecules, and the periodic table of elements.',
      duration: '18 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    },
    {
      id: 'science-102',
      title: 'The Solar System',
      subject: 'Science',
      description: 'Explore the planets, moons, and other objects in our solar system.',
      duration: '22 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    },
    {
      id: 'history-101',
      title: 'Ancient Civilizations',
      subject: 'History',
      description: 'Explore the rise and fall of ancient civilizations including Egypt, Greece, and Rome.',
      duration: '25 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    },
    {
      id: 'history-102',
      title: 'World War II',
      subject: 'History',
      description: 'An overview of the causes, major events, and consequences of World War II.',
      duration: '30 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    },
    {
      id: 'english-101',
      title: 'Grammar Essentials',
      subject: 'English',
      description: 'Master the fundamentals of English grammar, including parts of speech and sentence structure.',
      duration: '17 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    },
    {
      id: 'english-102',
      title: 'Creative Writing',
      subject: 'English',
      description: 'Learn techniques for effective storytelling and creative expression through writing.',
      duration: '24 min',
      videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
    }
  ];
  
  // Get day of week (0-6, where 0 is Sunday)
  const dayOfWeek = dateObj.getDay();
  
  // For weekends, return fewer lessons
  if (dayOfWeek === 0 || dayOfWeek === 6) {
    // Weekend - only return 1-2 lessons
    const startIndex = dateSeed % lessonLibrary.length;
    return [
      lessonLibrary[startIndex],
      lessonLibrary[(startIndex + 3) % lessonLibrary.length]
    ];
  } else {
    // Weekday - return 2-4 lessons
    const startIndex = dateSeed % lessonLibrary.length;
    return [
      lessonLibrary[startIndex],
      lessonLibrary[(startIndex + 2) % lessonLibrary.length],
      lessonLibrary[(startIndex + 4) % lessonLibrary.length],
      lessonLibrary[(startIndex + 6) % lessonLibrary.length]
    ];
  }
};

module.exports = {
  getVideoLessons
};
