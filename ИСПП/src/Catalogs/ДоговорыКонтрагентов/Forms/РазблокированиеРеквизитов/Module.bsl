
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапретРедактированияРеквизитовОбъектовПоддержкаПроектовСервер.НастроитьФормуРазблокированияРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовПоддержкаПроектовКлиент.РазрешитьРедактирование(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовПоддержкаПроектовКлиент.ПроверитьИспользованиеОбъекта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы
