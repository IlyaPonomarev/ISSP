#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Процедура сообщает пользователю об ошибках проведения по регистру ТоварыНаСкладах
//
// Параметры
//	Объект - проводимый документ
//	Отказ - признак отказа от проведения документа
//	РезультатЗапроса - информация об ошибках проведения по регистру
//
Процедура СообщитьОбОшибкахПроведения(Объект, Отказ, РезультатЗапроса) Экспорт
	
	ШаблонСообщения = НСтр("ru = 'Номенклатура: %Номенклатура%
		|Отрицательный остаток товара на складе %Склад% в количестве %Количество%'");
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Номенклатура%",
									ОбщегоНазначенияПоддержкаПроектов.ПолучитьПредставлениеНоменклатуры(Выборка.Номенклатура, Выборка.СерияНоменклатуры, Выборка.Партия));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%",       Строка(-Выборка.Количество) + " (" + Строка(Выборка.Упаковка) + ")");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%",            Строка(Выборка.Склад) + ?(ЗначениеЗаполнено(Выборка.МестоХранения), ", " + Выборка.МестоХранения, ""));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект,,, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли