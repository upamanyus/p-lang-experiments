type tEnterNewEpochArgs = (epoch: int);
event eEnterNewEpoch : tEnterNewEpochArgs;

type tEnterNewEpochReply = (epoch: int, val: data);
event eEnterNewEpochReply : tEnterNewEpochReply;

machine Replica {
  var epoch: int;
  var acceptedEpoch: int;
  var val : data;

  start state Main {

    on eEnterNewEpoch do (newEpoch: int) {
      if (newEpoch > epoch) {
        epoch = newEpoch;
      }
    }
  }
}

