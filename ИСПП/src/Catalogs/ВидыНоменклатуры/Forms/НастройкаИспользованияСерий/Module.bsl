
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИменаСохраняемыхРеквизитов = Справочники.ВидыНоменклатуры.ИменаРеквизитовДляФормыНастройкаИспользованияСерий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ИменаСохраняемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Не ИспользоватьНомерСерии Тогда
		ТекстСообщения = НСтр("ru = 'Не выполнена настройка использования реквизитов серии.'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

