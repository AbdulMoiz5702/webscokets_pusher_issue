
class  ApiServices {

  // base URL
  static String  basicUrl = 'http://192.168.1.33:8000/api';

  // category Apis
  static String  getAllCategories = '$basicUrl/category';
  static String  postAllCategories = '$basicUrl/category/store';
  static String  updateAllCategories = '$basicUrl/category/update';
  static String  deleteCategories = '$basicUrl/category/delete';
  static String  getRelatedExercisesCategories = '$basicUrl/category';

  // exercises related Apis
  static String  postExercise = '$basicUrl/exercise/';
  static String  updateExercise = '$basicUrl/exercise/update';
  static String  deleteExercise = '$basicUrl/exercise/delete';

   // get all users related Apis
  static String  getAllUsersInfo = '$basicUrl/users_information';
  static String  getAllProgramAssignedUser = '$basicUrl/program_assign_users?request_type=admin';
  static String  getAllUnAssignedUser = '$basicUrl/program_unassign_users?request_type=admin';


  // programs APis
  static String  getProgram = '$basicUrl/program?user_id=null&request_type=admin';
  static String  postProgram = '$basicUrl/program';
  static String  updateProgram = '$basicUrl/program';  // after program/id ( you understand )
  static String  destroyProgram = '$basicUrl/program';  // after program/id/destroy ( you understand )

  // days APis
  static String  getDay = '$basicUrl/day';
  static String  postDay = '$basicUrl/day';
  static String  updateDay = '$basicUrl/day';  // after day/id ( you understand )
  static String  destroyDay = '$basicUrl/day';  // after day/id/destroy ( you understand )

  //get user day
  static String  getUserDay = '$basicUrl/day';

  // days exercises APis
  static String  getDayExercises = '$basicUrl/day_exercise';
  static String  postDayExercises = '$basicUrl/day_exercise';
  static String  updateDayExercises = '$basicUrl/day_exercise';  // after day/id ( you understand )
  static String  destroyDayExercises = '$basicUrl/day_exercise';  // after day/id/destroy ( you understand )

  // get user day_exercises
  static String getUserDayExercises = '$basicUrl/day_exercise';

   // sets APis
  static String  getSets = '$basicUrl/set';
  static String  postSets = '$basicUrl/set';
  static String  updateSets = '$basicUrl/set';  // after set/id ( you understand )
  static String  destroySets = '$basicUrl/set';  // after set/id/destroy ( you understand )

  // get user sets
  static String  getUserSets = '$basicUrl/set';

  // assign workout program
  static String  assignWorkoutProgram = '$basicUrl/program_assign';
  static String  getAssignWorkoutProgram = '$basicUrl/user_assigned_programs';
  static String  deleteAssignWorkoutProgram = '$basicUrl/assigned_program';

  // user Assign Program Api
  static String userProgramAssign = '$basicUrl/program?';
  // is completed Apis
  static String setCompleted = '$basicUrl/set/isCompleted';


  // Messaging APis

  static String sendMessageapi = '$basicUrl/send-message';
  static String fetchMessageapi = '$basicUrl/messages?request_type=admin&user_id';
}