ACTION_THRESHOLDS = [3, 15, 35, 63, 99]
SHIELD_THRESHOLDS = [8, 24, 48, 80]

plur = (num, word) ->
  if num is 1
    return word
  else
    return "#{word}s"


$( ->
  rep = parseInt(localStorage.mage_knight_current_reputation or 0)
  $(".currentReputation").text(rep)
  
  fame = parseInt(localStorage.mage_knight_current_fame or 0)
  $(".currentFame").text(fame)
  
  $(".reset").click( ->
    confirmed = window.confirm("Really reset? You can't undo this.")
    return unless confirmed
    localStorage.mage_knight_current_reputation = 0
    localStorage.mage_knight_current_fame = 0
    $(".currentReputation").text(0)
    $(".currentFame").text(0)
  )                 
  
  $(".incrCurrentReputation").mousedown( ->
    newRep = parseInt($(".currentReputation").text(), 10) + 1  
    localStorage.mage_knight_current_reputation = newRep
    $(".currentReputation").text(
      newRep
    )
  )

  $(".decrCurrentReputation").mousedown( ->
    newRep = parseInt($(".currentReputation").text(), 10) - 1  
    localStorage.mage_knight_current_reputation = newRep
    $(".currentReputation").text(
      newRep
    )
  )
  
  $(".addFameButton").click( ->
    $(".view").hide()
    $(".editView").show()
  )
    
  $(".incrNewFame").mousedown( ->
    $(".newFame").text(
      parseInt($(".newFame").text(), 10) + 1
    )
  )
    
  $(".decrNewFame").mousedown( ->
    $(".newFame").text(
      parseInt($(".newFame").text(), 10) - 1
    )
  )
    
  $(".doneNewFame").click( ->
    addedVal = parseInt($(".newFame").text(), 10)
    oldFame = parseInt($(".currentFame").text(), 10)
    newFame = addedVal + oldFame
    localStorage.mage_knight_current_fame = newFame
    action_bumps = 0
    level_bumps = 0
    total_shields = 1
    total_skills = 0
    for step in [oldFame...newFame]
        if _(ACTION_THRESHOLDS).contains(step)
            action_bumps += 1
            total_skills = ACTION_THRESHOLDS.indexOf(step) + 1
        if _(SHIELD_THRESHOLDS).contains(step)
            level_bumps += 1
            total_shields = SHIELD_THRESHOLDS.indexOf(step) + 2
    message = undefined
    if action_bumps >= 1
      message = """
        You may now choose #{action_bumps} new Advanced Action
        #{plur(action_bumps, "card")} and #{action_bumps} new Character
        #{plur(action_bumps, "Skill")}.<br/><br/>
        You should now have a total of #{total_skills} Character #{plur(total_skills, "Skill")}.
      """
    if level_bumps >= 1
      message = """You may now take #{level_bumps} #{plur(level_bumps, "shield")} from your
      stack and flip it over.<br /><br />
      You should now have a total of #{total_shields}
      available #{plur(total_shields, "shield")}."""
    if (action_bumps >= 1) and (level_bumps >= 1)
      message = "You may now take #{level_bumps} shield from your stack, #{action_bumps} Advanced Action card and #{action_bumps} Character Skill."


    nextLevel = Math.min.apply(null, 
      _(_(ACTION_THRESHOLDS).union(SHIELD_THRESHOLDS)).filter((item) -> item > newFame )
    )
    if not message?
      message = "You will get another benefit at Fame #{nextLevel}."

    $(".newFame").text(0)
    $(".currentFame").text(newFame)
    $(".fame.odometer").text(newFame)
    $(".view").hide()
    $(".effectView").show()
    $(".effect").html(message)
  )  
  $(".button.ok").click( ->
    $(".view").hide()
    $(".mainDisplay").show()
  )                     
)
