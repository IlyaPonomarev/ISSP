
&НаКлиенте
Процедура ЗагрузитьИзExcel(Команда)
	
ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьИзExcelЗаверешение", ЭтотОбъект);	
	
ПоказатьВопрос(ОписаниеОповещения,"Табличная часть будет очищена! Вы уверены что хотите продолжить?", РежимДиалогаВопрос.ДаНет);	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзExcelЗаверешение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеПодбораТовара", ЭтотОбъект);	
		ОткрытьФорму("Документ.ЗаявкаПредприятия.Форма.ФормаЗагрузкаИзExcel",,,,,, ОповещениеОЗакрытии);	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодбораТовара(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		ПослеПодбораТовараНаСервере(Результат);
		Модифицированность = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПослеПодбораТовараНаСервере(Результат)
	Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(Результат));
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьСпецификацию(Команда)
	
    Если НЕ ЗначениеЗаполнено(Объект.СпецификацияКДоговору) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Внимание! Не заполнена спцеификация!");
		Возврат;	
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьСпецификациюЗавершение", ЭтотОбъект);
	
	ТекущийСтатусСпецификации = ПолучитьСтатусСпецификации(Объект.СпецификацияКДоговору); 
	
	Если  ТекущийСтатусСпецификации <> ПредопределенноеЗначение("Перечисление.СтатусыСпецификацийКДоговорам.Проработка") Тогда
		ТекстВопроса = "Внимание! Спецификация в статусе """ + ТекущийСтатусСпецификации + """, вы уверены что хотите продолжить?";
	Иначе
		ТекстВопроса = "Внимание! Спецификация будет обновлена, вы уверены что хотите продолжить?";
	КонецЕсли;
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСпецификациюЗавершение (Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОбновитьСпецификациюНаСервере();	
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервереБезКонтекста 
Функция ПолучитьСтатусСпецификации(Специфкация)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Специфкация, "Статус"); 
КонецФункции	

&НаСервере
Процедура ОбновитьСпецификациюНаСервере()

	СпецификацияКДоговору = Объект.СпецификацияКДоговору;
	
	//Получим текущие товары в составе спецификации по текущей заявке
	
	ТаблицаТоваровВнутриСпецификации = ПолучитьТоварыВСпецификацииПоЗаявке(СпецификацияКДоговору, Объект.Ссылка);
	
	ТаблицаРазниц = Объект.Товары.Выгрузить();
	
	Для Каждого СтрокаТовар Из ТаблицаРазниц Цикл
		
		СтрокаТовараВНутриСпецификации = ТаблицаТоваровВнутриСпецификации.Найти(СтрокаТовар.Номенклатура);
		
		Если СтрокаТовараВНутриСпецификации <> Неопределено Тогда
			СтрокаТовар.Количество = СтрокаТовар.Количество - СтрокаТовараВНутриСпецификации.Количество; 	
		КонецЕсли;	
		
	КонецЦикла;
	
	//Изменим спецификацию
	
	ДокСпецификация = СпецификацияКДоговору.ПолучитьОбъект();
	
	ТоварыСпецификации = ДокСпецификация.Товары.Выгрузить();
	
	Для Каждого СтрокаТаблицыРазниц Из ТаблицаРазниц Цикл
		НоваяСтрокаСпецификации = ТоварыСпецификации.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаСпецификации, СтрокаТаблицыРазниц);
		НоваяСтрокаСпецификации.ЕдиницаИзмерения = НоваяСтрокаСпецификации.Номенклатура.ЕдиницаИзмерения;
		НоваяСтрокаСпецификации.СтавкаНДС = НоваяСтрокаСпецификации.Номенклатура.СтавкаНДС;
	КонецЦикла;
	
	ТоварыСпецификации.Свернуть("НоменклатураПоставщика, Номенклатура, ЕдиницаИзмерения, Штрихкод, СтавкаНДС", "Количество");
	
	МассивКУдалению = Новый Массив;
	
	Для Каждого СтрокаТч Из ДокСпецификация.НоменклатураПоЗаявкамПредприятий Цикл
		Если СтрокаТЧ.ЗаявкаПредприятия = Объект.Ссылка Тогда
			МассивКУдалению.Добавить(СтрокаТч);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаУдаления ИЗ МассивКУдалению Цикл
		ДокСпецификация.НоменклатураПоЗаявкамПредприятий.Удалить(СтрокаУдаления);		
	КонецЦикла;	
	
	ДокСпецификация.Товары.Загрузить(ТоварыСпецификации);
	
	ТаблицаНоменклатураПоЗаявкамПредприятий = Объект.Товары.Выгрузить();
	
	Для Каждого СтрокаТабНом ИЗ ТаблицаНоменклатураПоЗаявкамПредприятий Цикл
		НоваяСтрока = ДокСпецификация.НоменклатураПоЗаявкамПредприятий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабНом);
		НоваяСтрока.ЗаявкаПредприятия = Объект.Ссылка;
	КонецЦикла;	
	
	ДокСпецификация.Записать();
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьТоварыВСпецификацииПоЗаявке(СпецификацияКДоговору, ЗаявкаПредприятия)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацияКДоговоруНоменклатураПоЗаявкамПредприятий.ЗаявкаПредприятия КАК ЗаявкаПредприятия,
	|	СпецификацияКДоговоруНоменклатураПоЗаявкамПредприятий.Номенклатура КАК Номенклатура,
	|	СпецификацияКДоговоруНоменклатураПоЗаявкамПредприятий.Количество КАК Количество
	|ИЗ
	|	Документ.СпецификацияКДоговору.НоменклатураПоЗаявкамПредприятий КАК СпецификацияКДоговоруНоменклатураПоЗаявкамПредприятий
	|ГДЕ
	|	СпецификацияКДоговоруНоменклатураПоЗаявкамПредприятий.Ссылка = &СпецификацияКДоговору
	|	И СпецификацияКДоговоруНоменклатураПоЗаявкамПредприятий.ЗаявкаПредприятия = &ЗаявкаПредприятия";
	
	Запрос.УстановитьПараметр("СпецификацияКДоговору", СпецификацияКДоговору);
	Запрос.УстановитьПараметр("ЗаявкаПредприятия", ЗаявкаПредприятия);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции	