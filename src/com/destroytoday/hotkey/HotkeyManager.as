/*
Copyright (c) 2011 Jonnie Hallman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.destroytoday.hotkey
{
	import com.destroytoday.object.ObjectMap;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;

	public class HotkeyManager
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var stageMap:ObjectMap = new ObjectMap();

		protected var hotkeyMap:Object = new Object();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function HotkeyManager()
		{
		}

		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------

		public function addStage(stage:Stage):Stage
		{
			if (hasStage(stage))
				throw new ArgumentError("Stage has already been added");
			
			stageMap.mapValue(stage, true)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			return stage;
		}
		
		public function removeStage(stage:Stage):Stage
		{
			if (!hasStage(stage))
				throw new ArgumentError("Attempting to remove Stage that hasn't been previously added");
			
			stageMap.unmapValue(stage)
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			return stage;
		}
		
		public function hasStage(stage:Stage):Boolean
		{
			return stageMap[stage] === true;
		}
		
		public function addHotkeyCombo(combination:String):IHotkey
		{
			if (hasHotkeyCombo(combination))
				throw new ArgumentError("A hotkey with combination <" + combination + "> already exists");
			
			return (hotkeyMap[combination] = new Hotkey(combination));
		}
		
		public function removeHotkeyCombo(combination:String):IHotkey
		{
			if (!hasHotkeyCombo(combination))
				throw new ArgumentError("Hotkey with combination <" + combination + "> does not exist");
			
			var hotkey:IHotkey = getHotkey(combination);
			
			delete hotkeyMap[combination];
			
			return hotkey;
		}
		
		public function hasHotkeyCombo(combination:String):Boolean
		{
			return hotkeyMap[combination] != undefined;
		}
		
		public function addHotkey(hotkey:IHotkey):IHotkey
		{
			if (hasHotkey(hotkey))
				throw new ArgumentError("A hotkey with combination <" + hotkey.combination + "> already exists");
			
			return (hotkeyMap[hotkey.combination] = hotkey);
		}

		public function removeHotkey(hotkey:IHotkey):IHotkey
		{
			if (!hasHotkey(hotkey))
				throw new ArgumentError("Hotkey with combination <" + hotkey.combination + "> does not exist");
			
			delete hotkeyMap[hotkey.combination];
			
			return hotkey;
		}
		
		public function getHotkey(combination:String):IHotkey
		{
			if (!hasHotkeyCombo(combination))
				throw new ArgumentError("A hotkey with combination <" + combination + "> does not exist");
			
			return hotkeyMap[combination];
		}

		public function hasHotkey(hotkey:IHotkey):Boolean
		{
			return hotkeyMap[hotkey.combination] != undefined;
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function keyDownHandler(event:KeyboardEvent):void
		{
			var charCodeModifierStr:String = '';
			var keyCodeModifierStr:String = '';
			
			if (event.commandKey)
			{
				charCodeModifierStr += "command+";
				keyCodeModifierStr += "command+";
			}
			
			if (event.controlKey)
			{
				charCodeModifierStr += "control+";
				keyCodeModifierStr += "control+";
			}
			
			if (event.altKey)
				keyCodeModifierStr += "alt+";
			
			if (event.shiftKey)
				keyCodeModifierStr += "shift+";

			var charCodeCombo:String = charCodeModifierStr + String.fromCharCode(event.charCode);
			var keyCodeCombo:String = keyCodeModifierStr + String(event.keyCode);

			var hotkey:IHotkey;

			if (((hotkey = hotkeyMap[charCodeCombo]) || (hotkey = hotkeyMap[keyCodeCombo])) && hotkey.enabled)
				hotkey.execute();
		}
	}
}