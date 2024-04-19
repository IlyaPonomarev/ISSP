#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЭтоГруппа Тогда
		
		ПрочиеРасходы = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ПрочиеРасходы"));
		
		Если Не ПустаяСтрока(КорреспондирующийСчет) Тогда
			Если ПустаяСтрока(СтрЗаменить(КорреспондирующийСчет, ".", "")) Тогда
				КорреспондирующийСчет = "";
			Иначе
				Пока Прав(СокрЛП(КорреспондирующийСчет), 1) = "." Цикл
					КорреспондирующийСчет = Лев(СокрЛП(КорреспондирующийСчет), СтрДлина(СокрЛП(КорреспондирующийСчет)) - 1);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ОграничитьИспользование И ДоступныеХозяйственныеОперации.Количество() > 0 Тогда
			ДоступныеХозяйственныеОперации.Очистить();
		ИначеЕсли ОграничитьИспользование И ДоступныеХозяйственныеОперации.Количество() = 0 Тогда
			ОграничитьИспользование = Ложь;
		КонецЕсли;
		
		Если ОграничитьИспользование Тогда
			ПланыВидовХарактеристик.СтатьиРасходов.ОчиститьНедоступныеХозяйственныеОперации(
				ВариантРаспределенияРасходов, ДоступныеХозяйственныеОперации, ДоступныеОперации);
		ИначеЕсли Не ПустаяСтрока(ДоступныеОперации) Тогда
			ДоступныеОперации = "";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#КонецЕсли
