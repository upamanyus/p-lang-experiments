// NOTE: annoying that the "source" type has to be in the args
type tEnterNewEpochArgs = (source:Proposer, epoch: int);
event eEnterNewEpoch : tEnterNewEpochArgs;

type tEnterNewEpochReply = (source: Replica, epoch: int, newEpoch:int, val: data);
event eEnterNewEpochReply : tEnterNewEpochReply;

type tProposeArgs = (source:Proposer, epoch: int, val: data);
event ePropose : tProposeArgs;

type tProposeReply = (source: Replica, epoch: int);
event eProposeReply : tProposeReply;

machine Replica {
  var epoch: int;
  var acceptedEpoch: int;
  var val : data;

  start state Main {

    entry (inVal: data) {
      val = inVal;
    }

    on eEnterNewEpoch do (req:tEnterNewEpochArgs) {
      // NOTE: annoying that variables must be declared at the top
      var reply: tEnterNewEpochReply;
      if (req.epoch > epoch) {
        epoch = req.epoch;
        reply = (source = this, epoch = acceptedEpoch, newEpoch = req.epoch, val = val);
        UnReliableSend(req.source, eEnterNewEpochReply, reply);
      }
    }

    on ePropose do (req:tProposeArgs) {
      var reply: tProposeReply;
      if (epoch <= req.epoch) {
        epoch = req.epoch;
        val = req.val;
        // NOTE: why couldn't I do:
        // reply = (epoch = epoch);
        // like with other named tuples?
        reply.source = this;
        reply.epoch = epoch;
        UnReliableSend(req.source, eProposeReply, reply);
      }
    }
  }
}
