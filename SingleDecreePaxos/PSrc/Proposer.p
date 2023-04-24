// A Proposer is only for a single epoch.
machine Proposer {
  var epoch: int;
  var replicas : set[Replica];
  // NOTE: seems like you can't have variables only within a single state.
  var preparedReplicas: set[Replica];

  var val: data;
  var largestEpochSeen: int;

  // every proposer starts in its own unique epoch.
  start state Main {
    // determine an upper bound on what's been committed previously.
    entry {
      var replica: Replica;
      foreach(replica in replicas) {
        send replica, eEnterNewEpoch, (source = this, epoch = epoch);
      }
    }

    on eEnterNewEpochReply do (reply:tEnterNewEpochReply) {
      var replica: Replica;
      preparedReplicas += (reply.source);
      if (reply.epoch > largestEpochSeen) {
        largestEpochSeen = reply.epoch;
        val = reply.val;
      }

      if (2 * sizeof(preparedReplicas) > sizeof(replicas)) {
        // send out propose
        foreach(replica in replicas) {
          send replica, ePropose, (source = this, epoch = epoch, val = val);
        }
      }
    }
  }

}
