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
	import org.osflash.signals.Signal;
	
	public class Hotkey implements IHotkey
	{
		//--------------------------------------------------------------------------
		//
		//  Static Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const combinationValidationRegex:RegExp = /^(?:(?:(?:(?:command|control)\+){0,2}\S)|(?:(?:(?:command|control|alt|shift)\+){0,4}[0-9]+))$/;
		
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		protected var _executed:Signal;
		
		public function get executed():Signal
		{
			return _executed ||= new Signal();
		}
		
		public function set executed(value:Signal):void
		{
			if (value == _executed) return;
			
			_executed = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _combination:String;
		
		protected var _enabled:Boolean = true;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Hotkey(combination:*)
		{
			this.combination = String(combination);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		public function get combination():String
		{
			return _combination;
		}
		
		public function set combination(value:String):void
		{
			if (value == _combination) return;
			
			_combination = value;
			
			validateCombination();
			sortModifiers();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------
		
		protected function sortModifiers():void
		{
			var modifierStr:String = '';
			
			if (_combination.indexOf("command") != -1)
				modifierStr += "command+";
			
			if (_combination.indexOf("control") != -1)
				modifierStr += "control+";
			
			if (_combination.indexOf("alt") != -1)
				modifierStr += "alt+";
			
			if (_combination.indexOf("shift") != -1)
				modifierStr += "shift+";
			
			var combinationPartList:Array = _combination.split('+');
			
			_combination = modifierStr + combinationPartList[combinationPartList.length - 1];
		}
		
		protected function validateCombination():void
		{
			if (!combinationValidationRegex.test(_combination))
				throw new ArgumentError("Invalid hotkey combination");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		public function execute():void
		{
			executed.dispatch();
		}
		
		public function toString():String
		{
			return _combination;
		}
	}
}