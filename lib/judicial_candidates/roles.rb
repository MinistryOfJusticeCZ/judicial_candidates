require 'egov_utils/user_utils/role'

class AdminRole < EgovUtils::UserUtils::Role

  add 'admin'

  def define_abilities(ability, user)
    ability.can :manage, :all
  end

end


class CandidateRole < EgovUtils::UserUtils::Role

  add 'candidate'

  def define_abilities(ability, user)

    ability.can :create, Candidate unless Candidate.where(user_id: user.id).exists?
    ability.can :read, Candidate, user_id: user.id
    ability.can :manage, Candidate, user_id: user.id, state: Candidate.states[:incomplete]
    ability.can :read, EntryTest, candidate_entry_tests: { candidate: { user_id: user.id } }
    ability.can :read, CandidateEntryTest, candidate: { user_id: user.id }
    # ability.can :manage, CandidateEntryTest, CandidateEntryTest.comming.joins(:candidate).where(Candidate.arel_table[:user_id].eq(user.id))
    ability.can :read, Interview, candidate_interviews: { candidate: { user_id: user.id } }
  end

end

class JusticeOrganizationRole < EgovUtils::UserUtils::Role

  add 'ooj'

  def define_abilities(ability, user)
    ability.can :read, Candidate
    ability.can [:approve, :disapprove], Candidate, state: Candidate.states[:validation]
  end

end

class JusticeAcademyRole < EgovUtils::UserUtils::Role

  add 'academy'

  def define_abilities(ability, user)
    ability.can :read, Candidate, state: Candidate.states[:waiting]
    ability.can :manage, EntryTest
    ability.can :manage, CandidateEntryTest
  end

end

class JudgeRole < EgovUtils::UserUtils::Role

  add 'judge'

  def define_abilities(ability, user)
    ability.can :manage, Interview #TODO: jen jeho okrsek
  end

end
