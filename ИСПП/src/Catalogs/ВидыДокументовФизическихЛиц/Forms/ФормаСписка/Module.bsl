#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Возврат; // в УТ11 не используется
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	Возврат; // в УТ11 не используется
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	Возврат; // в УТ11 не используется
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПодсистемыНастройкиПорядкаЭлементов

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти
