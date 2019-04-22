require 'egov_utils/user_utils/role'

class AdminRole < EgovUtils::UserUtils::Role

  add 'admin'

  def define_abilities(ability, user)
    ability.can :manage, :all
  end

end

class AnonymousRole < EgovUtils::UserUtils::Role

  add 'anonymous'

  def define_abilities(ability, user)
    ability.can :index, EntryTest, state: ['unconfirmed', 'listed']
  end

end


class CandidateRole < EgovUtils::UserUtils::Role

  add 'candidate'

  def define_abilities(ability, user)
    ability.can :create, Candidate unless Candidate.where(user_id: user.id).exists?
    ability.can :read, Candidate, user_id: user.id
    ability.can :manage, Candidate, user_id: user.id, state: Candidate.states[:incomplete]
    ability.cannot :index, Candidate
    ability.can :read, EntryTest, candidate_entry_tests: { candidate: { user_id: user.id } }
    ability.can :read, CandidateEntryTest, candidate: { user_id: user.id }
    ability.can :update, CandidateEntryTest, candidate: { user_id: user.id }
    # ability.can :manage, CandidateEntryTest, CandidateEntryTest.comming.joins(:candidate).where(Candidate.arel_table[:user_id].eq(user.id))
    ability.can :read, Interview, candidate_interviews: { candidate: { user_id: user.id } }
    ability.can :update, CandidateInterview, candidate: { user_id: user.id }
  end

end

class JusticeOrganizationRole < EgovUtils::UserUtils::Role

  add 'ooj'

  def define_abilities(ability, user)
    ability.can :read, Candidate
    ability.can [:approve, :disapprove], Candidate, state: Candidate.states[:validation]
    ability.can :destroy, Candidate
    ability.can :index, EntryTest
  end

end

class JusticeAcademyRole < EgovUtils::UserUtils::Role

  add 'academy'

  def define_abilities(ability, user)
    ability.can :read, Candidate
    ability.can :manage, EntryTest
    ability.can :manage, CandidateEntryTest
  end

end

class JudgeRole < EgovUtils::UserUtils::Role

  add 'judge'

  def define_abilities(ability, user)
    ability.can :index, Candidate
    if user.organization_id
      ability.can :manage, Interview, region_court_id: user.organization_id
      ability.can [:update, :reject_apology], CandidateInterview, {interview: { region_court_id: user.organization_id }}
    else
      ability.can :manage, Interview
      ability.can [:update, :reject_apology], CandidateInterview
    end
  end

end
