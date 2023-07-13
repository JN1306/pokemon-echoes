class BossEff_UseMoveRandom < BossEffect
  def initialize(trigger, move=[], move_target_idx=-1)
    super(trigger)
    @move = move
    @move_target_idx = move_target_idx
  end
  def activate(battle, triggerer, target)
    move = move.length.shuffle[0]
    if @move_target_idx == -1
      target.effects[PBEffects::Instructed] = true
      target.pbUseMoveSimple(@move,-1,-1,false)
      target.effects[PBEffects::Instructed] = false
    else
      possible_targets = []
      if @move_target_idx.is_a?(Array)
        for t in @move_target_idx
          if !battle.battlers[t].fainted?
            possible_targets.push(battle.battlers[t])
          end
        end
      else
        if !battle.battlers[@move_target_idx].fainted?
          possible_targets.push(battle.battlers[@move_target_idx])
        end
      end
      move_target = possible_targets.shuffle[0]
      target.effects[PBEffects::Instructed] = true
      target.pbUseMoveSimple(@move,move_target.index,-1,false)
      target.effects[PBEffects::Instructed] = false
    end
  end
end
