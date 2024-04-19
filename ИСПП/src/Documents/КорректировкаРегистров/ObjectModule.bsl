#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЭтоНовый() И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(Не ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает флаг активности движений документа
//
Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	ИменаРегистров = ПроведениеПоддержкаПроектов.ПолучитьИменаИспользуемыхРегистров(Ссылка, Метаданные().Движения);
	Для Каждого ИмяРегистра Из ИменаРегистров Цикл
		
		Движение = Движения[ИмяРегистра];
		Движение.Записывать = Истина;
		Движение.Прочитать();
		Движение.УстановитьАктивность(ФлагАктивности);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли