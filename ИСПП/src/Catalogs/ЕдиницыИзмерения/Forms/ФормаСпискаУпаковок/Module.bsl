
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Номенклатура", Номенклатура) Тогда
		Параметры.Отбор.Удалить("Номенклатура");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Номенклатура", Номенклатура);
	
	Если Не ЗначениеЗаполнено(Номенклатура) Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ТипНоменклатуры") = Перечисления.ТипыНоменклатуры.Услуга Тогда
		ТолькоПросмотр = Истина;
		ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Номенклатура%"" упаковки не используются'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Номенклатура%", СокрЛП(Номенклатура));
		
		АвтоЗаголовок = Ложь;
		Заголовок     = ТекстЗаголовка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если Копирование Тогда
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
		ЗначенияЗаполнения = Новый Структура("Номенклатура", Номенклатура);
		
		Если ТекущаяСтрока <> Неопределено Тогда
			Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
				ЗначенияЗаполнения.Вставить("Родитель", ТекущаяСтрока.Ссылка);
			КонецЕсли;
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ЕдиницыИзмерения.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы
