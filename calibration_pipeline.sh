
# Initial guess

DOCKER_IMAGE=docker.io/gc625kodifly/direct_visual_lidar_calibration_superglue:noetic
ROSBAG_PATH=/home/gabriel/liv_data/outdoor_bags
RESULTS_PATH=/home/gabriel/direct_visual_lidar_calibration/results

# preprocess rosbags
docker run \
  --rm \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v ${ROSBAG_PATH}:/tmp/input_bags \
  -v ${RESULTS_PATH}:/tmp/preprocessed \
  ${DOCKER_IMAGE} \
  rosrun direct_visual_lidar_calibration preprocess /tmp/input_bags /tmp/preprocessed -adv \
  # --camera_intrinsic 1740.487997,706.1426419,1740.755014,559.7166505 \
  # --camera_distortion_coeffs -0.06317058805,0.141866059,0.0003422750586,-0.0006826149506,-0.1160125446 \
  # --camera_model plumb_bob

docker run \
  -it \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v ${RESULTS_PATH}:/tmp/preprocessed \
  ${DOCKER_IMAGE} \
  rosrun direct_visual_lidar_calibration find_matches_superglue.py /tmp/preprocessed

# Initial guess
docker run \
  --rm \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v ${RESULTS_PATH}:/tmp/preprocessed \
  ${DOCKER_IMAGE} \
  rosrun direct_visual_lidar_calibration initial_guess_auto /tmp/preprocessed

# Calibration

# Initial guess
docker run \
  --rm \
  --net host \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v ${RESULTS_PATH}:/tmp/preprocessed \
  ${DOCKER_IMAGE} \
  rosrun direct_visual_lidar_calibration calibrate /tmp/preprocessed