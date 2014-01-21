ACTION_THRESHOLDS = [3, 15, 35, 63, 99]
SHIELD_THRESHOLDS = [8, 24, 48, 80]

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
    message = "Done. Your Fame level is now #{newFame}"
    if action_bumps >= 1
        message = "Awesome! Now that your Fame level is #{newFame}, you may now choose #{action_bumps} new Advanced Action card and #{action_bumps} new Character Skill.<br/><br/>You should now have a total of #{total_skills} Character Skills."
    if level_bumps >= 1
        message = "Great news! Now that your Fame has increased to #{newFame}, you may now take #{level_bumps} shield from your stack and flip it over.<br /><br />You should now have a total of #{total_shields} available shields."
    $(".newFame").text(0)
    $(".currentFame").text(newFame)
    $(".view").hide()
    $(".effectView").show()
    $(".effect").html(message)
  )  
  $(".button.ok").click( ->
    $(".view").hide()
    $(".mainDisplay").show()
  )                     
)
