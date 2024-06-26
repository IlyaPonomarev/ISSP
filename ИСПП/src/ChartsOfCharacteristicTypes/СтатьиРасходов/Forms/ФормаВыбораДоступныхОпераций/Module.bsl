
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСписокХозяйственныхОпераций(
		ДоступныеХозяйственныеОперации,
		Параметры.ВариантРаспределенияРасходов);
	
	Если ТипЗнч(Параметры.ВыбранныеОперации) = Тип("Массив") Тогда
		
		Для Каждого ХозяйственнаяОперация Из Параметры.ВыбранныеОперации Цикл
			ЭлементСписка = ДоступныеХозяйственныеОперации.НайтиПоЗначению(ХозяйственнаяОперация);
			Если ЭлементСписка <> Неопределено Тогда
				ЭлементСписка.Пометка = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОповеститьОВыборе(ДоступныеХозяйственныеОперации);
	
КонецПроцедуры

#КонецОбласти
