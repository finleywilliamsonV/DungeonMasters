package {

	import flash.display.MovieClip;


	public class MonsterInfoPanel extends MovieClip {

		// above
		public var monsterBuyPanel: MonsterBuyPanel;

		// below
		public var selected: Monster;
		public var isUnlocked:Boolean;
		
		public var lockScreen:MonsterInfoPanel_Locked;

		// constructor code
		public function MonsterInfoPanel($monsterBuyPanel: MonsterBuyPanel) {
			monsterBuyPanel = $monsterBuyPanel;
			
			lockScreen = new MonsterInfoPanel_Locked();
			addChild(lockScreen);
			lockScreen.visible = false;
		}

		public function setSelected($selected): void {
			selected = $selected;

			abilitiesBar.setup(selected);
			starDisplay.setStars(selected.starLevel);
			
			monsterSprites.gotoMonster($selected);
			
			nameText.text = selected.ui_name;

			maxHealthText.text = selected.maxHealth.toString();
			maxManaText.text = selected.maxMana.toString();
			attackText.text = selected.attack.toString();
			defenseText.text = selected.defense.toString();
			magicAttackText.text = selected.magicAttack.toString();
			magicDefenseText.text = selected.magicDefense.toString();
			dexterityText.text = selected.dexterity.toString();
			sightDistanceText.text = selected.sightDistance.toString();
			
			if ($selected.description) descriptionText.text = $selected.description;
			else descriptionText.text = "This is a " + selected.ui_name + ". It has a star level of " + selected.starLevel + " and " + selected.abilities.length + " attacks.";
			
			
			// fill out purchase data
			currentGoldText.text = GlobalVariables.gameplayScreen.gold.toString();
			costText.text =	selected.goldCost.toString();
			
			var equippedMonster:Monster = monsterBuyPanel.monsterBuyScreen.equippedMonster;
			if (equippedMonster) {
				creditText.text = (equippedMonster.goldCost/4).toString();
			} else {
				creditText.text = "0";
			}
			var total : int = GlobalVariables.gameplayScreen.gold - selected.goldCost + int(creditText.text);
			totalText.text = total.toString();

			var monsterClass : Class = GlobalVariables.instance.getClass(selected);
			
			trace("																				!!! " + monsterClass + " - " + equippedMonster);
			
			if (equippedMonster is monsterClass) buyButton.gotoAndStop(3);
			else if (total < 0) buyButton.gotoAndStop(2);
			else buyButton.gotoAndStop(1);
			
			if (GlobalUnlockTracker.instance.isUnlocked(monsterClass)) {
				lockScreen.visible = false;
			} else {
				lockScreen.visible = true;
				var tempCriteria : UnlockCriteria = GlobalUnlockTracker.instance.getCriteriaFromClassName(monsterClass);
				lockScreen.nameText.text = selected.ui_name;
				lockScreen.unlockText.text = tempCriteria.unlockText;
				lockScreen.monsterLockedBar.trackerSlider.trackerText.text = tempCriteria.progressTracker.toString();
				lockScreen.monsterLockedBar.completionText.text = tempCriteria.progressCompletion.toString();
				
				var numerator:int = int(tempCriteria.progressTracker.toString());
				var denominator:int = int(tempCriteria.progressCompletion.toString());
				
				lockScreen.monsterLockedBar.update(numerator/denominator);
			}
			
			
		}
	}

}