// NOTE: annoying that the "source" type has to be in the args
type tEnterNewEpochArgs = (source:Proposer, epoch: int);
event eEnterNewEpoch : tEnterNewEpochArgs;

type tEnterNewEpochReply = (epoch: int, newEpoch:int, val: data);
event eEnterNewEpochReply : tEnterNewEpochReply;

type tProposeArgs = (source:Proposer, epoch: int, val: data);
event ePropose : tProposeArgs;

type tProposeReply = (epoch: int);
event eProposeReply : tProposeReply;

machine Replica {
  var epoch: int;
  var acceptedEpoch: int;
  var val : data;

  start state Main {
    on eEnterNewEpoch do (req:tEnterNewEpochArgs) {
      // NOTE: annoying that variables must be declared at the top
      var reply: tEnterNewEpochReply;
      if (req.epoch > epoch) {
        epoch = req.epoch;
        reply = (epoch = acceptedEpoch, newEpoch = acceptedEpoch, val = val);
        send req.source, eEnterNewEpochReply, reply;
      }
    }

    on ePropose do (req:tProposeArgs) {
      var reply: tProposeReply;
      if (epoch <= req.epoch) {
        epoch = req.epoch;
        val = req.val;
        reply.epoch = epoch;
        send req.source, eProposeReply, reply;
      }
    }
  }
}
