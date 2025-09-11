String formatDuration(int seconds) {
  int hours = seconds ~/ 3600; // Get hours
  int minutes = (seconds % 3600) ~/ 60; // Get minutes
  int remainingSeconds = seconds % 60; // Get remaining seconds

  // Build the formatted string
  String formattedDuration = '';
  
  if (hours > 0) {
    formattedDuration += '${hours}h ';
  }
  if (minutes > 0) {
    formattedDuration += '${minutes}m ';
  }
  if (remainingSeconds > 0 || formattedDuration.isEmpty) {
    formattedDuration += '${remainingSeconds}s';
  }

  return formattedDuration.trim();
}