import React, { useState } from 'react';
import ReactPlayer from 'react-player';
import { FaPlay, FaPause, FaExpand, FaVolumeUp, FaVolumeMute } from 'react-icons/fa';

function VideoPlayer({ url }) {
  const [playing, setPlaying] = useState(false);
  const [volume, setVolume] = useState(0.8);
  const [muted, setMuted] = useState(false);
  const [played, setPlayed] = useState(0);
  const [seeking, setSeeking] = useState(false);

  // Player reference
  const playerRef = React.useRef(null);

  // Format time in seconds to MM:SS format
  const formatTime = (seconds) => {
    if (isNaN(seconds)) return '00:00';
    
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    
    return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
  };

  // Handle play/pause toggle
  const handlePlayPause = () => {
    setPlaying(!playing);
  };

  // Handle volume change
  const handleVolumeChange = (e) => {
    setVolume(parseFloat(e.target.value));
  };

  // Handle mute toggle
  const handleMuteToggle = () => {
    setMuted(!muted);
  };

  // Handle seeking
  const handleSeekMouseDown = () => {
    setSeeking(true);
  };

  const handleSeekChange = (e) => {
    setPlayed(parseFloat(e.target.value));
  };

  const handleSeekMouseUp = (e) => {
    setSeeking(false);
    playerRef.current.seekTo(parseFloat(e.target.value));
  };

  // Handle progress
  const handleProgress = (state) => {
    if (!seeking) {
      setPlayed(state.played);
    }
  };

  return (
    <div className="video-player-container relative bg-black rounded-lg overflow-hidden">
      <div className="player-wrapper relative pt-[56.25%]">
        <ReactPlayer
          ref={playerRef}
          className="absolute top-0 left-0"
          url={url}
          width="100%"
          height="100%"
          playing={playing}
          volume={volume}
          muted={muted}
          onProgress={handleProgress}
          config={{
            file: {
              attributes: {
                controlsList: 'nodownload'
              }
            }
          }}
        />
      </div>
      
      {/* Custom controls */}
      <div className="video-controls bg-gray-900 text-white p-3">
        <div className="flex items-center mb-2">
          <button 
            onClick={handlePlayPause} 
            className="mr-3 focus:outline-none"
            aria-label={playing ? 'Pause' : 'Play'}
          >
            {playing ? <FaPause /> : <FaPlay />}
          </button>
          
          <div className="flex-1 mx-2">
            <input
              type="range"
              min={0}
              max={1}
              step="any"
              value={played}
              onMouseDown={handleSeekMouseDown}
              onChange={handleSeekChange}
              onMouseUp={handleSeekMouseUp}
              className="w-full accent-blue-500 cursor-pointer"
            />
          </div>
          
          <button 
            onClick={handleMuteToggle} 
            className="mx-2 focus:outline-none"
            aria-label={muted ? 'Unmute' : 'Mute'}
          >
            {muted ? <FaVolumeMute /> : <FaVolumeUp />}
          </button>
          
          <div className="w-20 mx-2 hidden sm:block">
            <input
              type="range"
              min={0}
              max={1}
              step="any"
              value={volume}
              onChange={handleVolumeChange}
              className="w-full accent-blue-500 cursor-pointer"
            />
          </div>
          
          <button 
            onClick={() => playerRef.current.getInternalPlayer().requestFullscreen()} 
            className="ml-2 focus:outline-none"
            aria-label="Full screen"
          >
            <FaExpand />
          </button>
        </div>
        
        <div className="flex justify-between text-xs text-gray-400">
          <span>{formatTime(played * playerRef.current?.getDuration() || 0)}</span>
          <span>{formatTime(playerRef.current?.getDuration() || 0)}</span>
        </div>
      </div>
    </div>
  );
}

export default VideoPlayer;
