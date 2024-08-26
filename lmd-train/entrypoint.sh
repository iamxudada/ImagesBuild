#!/bin/bash

init_hccl() {
   > /etc/hccn.conf
  HCCL_BIGIN_NUMS=$(( 8 * MACHINE_RANK ))
  for HCCL_BIGIN_NUM in $(seq $HCCL_BIGIN_NUMS $(( HCCL_BIGIN_NUMS + 7 ))); do
    /usr/local/Ascend/driver/tools/hccn_tool -i $(( HCCL_BIGIN_NUM % 8 )) -ip -s address 10.20.10.$(( HCCL_BIGIN_NUM + 1 )) netmask 255.255.255.0;
    /usr/local/Ascend/driver/tools/hccn_tool -i $(( HCCL_BIGIN_NUM % 8 )) -netdetect -s address 10.20.10.$(( HCCL_BIGIN_NUM + 1 ))
  done
}

evaluateState() {
  curl -sS -m 10 -X POST -H "content-type: application/json" -d "{\"modelEvaluationId\": $taskId, \"state\": \"$state\"}" $STATUS_URL
}

modelWeightMerge() {
  curl -sS -m 10 -X POST -H "content-type: application/json" -d "{\"mergeId\": $mergeId, \"state\": \"$state\"}" $STATUS_URL
}

changeTrainStatus(){
  curl -sS -m 10 -X POST -H "content-type: application/json" -d "{\"trainId\": $trainId, \"state\": \"$state\"}" $STATUS_URL
}

singleMachineModelTraining() {
  echo -e "\e[33m##-*----------------------- Start model training... -----------------------*-##\e[0m"
  # 默认使用所有显卡(一张也如此)
  ASCEND_RT_VISIBLE_DEVICES=$DEVICES_NUMS_IDS python3 src/train.py ${OPTIONS}
  if [ $? -ne 0 ]; then
    echo -e "\n\e[31m##-*----------------------- Model training failed! -----------------------*-##\e[0m"
    state=failed
  else
    echo -e "\n\e[32m##-*----------------------- Model training success! -----------------------*-##\e[0m"
    state=success
  fi
  changeTrainStatus
}


ModelWeightMerging() {
  echo -e "\e[33m##-*----------------------- Start weight merge... -----------------------*-##\e[0m"
  ASCEND_RT_VISIBLE_DEVICES=$DEVICES_NUMS_IDS \
  python3 src/export_model.py ${OPTIONS}
  if [ $? -ne 0 ]; then
    echo -e "\n\e[31m##-*----------------------- Model weight merge failed! -----------------------*-##\e[0m"
    state=failed
  else
    echo -e "\n\e[32m##-*----------------------- Model weight merge success! -----------------------*-##\e[0m"
    state=success
  fi
  modelWeightMerge
}

previewModel() {
  echo -e "\e[33m##-*----------------------- Start preview... -----------------------*-##\e[0m"
  # 默认使用所有显卡(一张也如此)
  ASCEND_RT_VISIBLE_DEVICES=$DEVICES_NUMS_IDS \
  API_PORT=$LMD_PORT_HTTP \
  python3 src/api.py ${OPTIONS}
  if [ $? -ne 0 ]; then
    echo -e "\n\e[31m##-*----------------------- Model preview failed! -----------------------*-##\e[0m"
  else
    echo -e "\n\e[32m##-*----------------------- Model preview success! -----------------------*-##\e[0m"
  fi
}

trainingOfDeepSpeed() {
  echo -e "\e[33m##-*----------------------- Start model training... -----------------------*-##\e[0m"
  # 默认使用所有显卡(一张也如此)
  ASCEND_RT_VISIBLE_DEVICES=$DEVICES_NUMS_IDS \
  deepspeed --num_gpus=$(echo $DEVICES_NUMS_IDS | awk -F, '{print NF}') \
  src/train.py --deepspeed source/input/ds_config.json ${OPTIONS}
  if [ $? -ne 0 ]; then
    echo -e "\n\e[31m##-*----------------------- Model training failed! -----------------------*-##\e[0m"
    state=failed
  else
    echo -e "\n\e[32m##-*----------------------- Model training success! -----------------------*-##\e[0m"
    state=success
  fi
  changeTrainStatus
}

multiTrainingOfDeepSpeed() {
  echo -e "\e[33m##-*----------------------- Start model training... -----------------------*-##\e[0m"
  # 默认使用所有显卡(一张也如此)
  init_hccl
  ASCEND_RT_VISIBLE_DEVICES=$DEVICES_NUMS_IDS \
  deepspeed --num_gpus=$(echo $DEVICES_NUMS_IDS | awk -F, '{print NF}') \
  src/train.py --deepspeed source/input/ds_config.json ${OPTIONS}
  if [ $? -ne 0 ]; then
    echo -e "\n\e[31m##-*----------------------- Model training failed! -----------------------*-##\e[0m"
    state=failed
  else
    echo -e "\n\e[32m##-*----------------------- Model training success! -----------------------*-##\e[0m"
    state=success
  fi
  changeTrainStatus
}



# Multi or Single Training of Accelerate
trainingOfAccelerate() {
  echo -e "\e[33m##-*----------------------- Start model training... -----------------------*-##\e[0m"
  ASCEND_RT_VISIBLE_DEVICES=$DEVICES_NUMS_IDS \
  NCCL_SOCKET_IFNAME=$NCCL_SOCKET_IFNAME \
  accelerate launch --config_file source/input/accelerate_config.yaml \
  src/train.py ${OPTIONS}
  if [ $? -ne 0 ]; then
    echo -e "\n\e[31m##-*----------------------- Model training failed! -----------------------*-##\e[0m"
    state=failed
  else
    echo -e "\n\e[32m##-*----------------------- Model training success! -----------------------*-##\e[0m"
    state=success
  fi
  changeTrainStatus

}

evaluate() {
  echo -e "\e[33m##-*----------------------- Start model evaluate... -----------------------*-##\e[0m"
  ASCEND_RT_VISIBLE_DEVICES=$DEVICES_NUMS_IDS \
  python3 src/evaluate.py ${OPTIONS}
  if [ $? -ne 0 ]; then
    echo -e "\n\e[31m##-*----------------------- Model evaluate failed! -----------------------*-##\e[0m"
    state=failed
  else
    echo -e "\n\e[32m##-*----------------------- Model evaluate success! -----------------------*-##\e[0m"
    state=success
  fi
  evaluateState
}


main() {
  echo -e "\e[33m##-*--------# Copyright (c) 2024-08-01 xulinchun <xulinchun0806@outlook.com>        *-##\e[0m"
  echo -e "\e[33m##-*--------#                                                                       *-##\e[0m"
  echo -e "\e[33m##-*--------# This file is part of SupieDT-LMD.                                     *-##\e[0m"

  source /usr/local/Ascend/ascend-toolkit/set_env.sh
  export HCCL_CONNECT_TIMEOUT=7200

  case $1 in
  singleMachineModelTraining)
    singleMachineModelTraining
    ;;
  ModelWeightMerging)
    ModelWeightMerging
    ;;
  previewModel)
    previewModel
    ;;
  trainingOfDeepSpeed)
    trainingOfDeepSpeed
    ;;
  multiTrainingOfDeepSpeed)
    multiTrainingOfDeepSpeed
    ;;
  trainingOfAccelerate)
    trainingOfAccelerate
    ;;
  evaluate)
    evaluate
    ;;
  *)
    echo "Option: {singleMachineModelTraining|ModelWeightMerging|previewModel|trainingOfDeepSpeed|multiTrainingOfDeepSpeed|trainingOfAccelerate|evaluate}"
    exit 1
    ;;
  esac
}

main "$@" || exit 1