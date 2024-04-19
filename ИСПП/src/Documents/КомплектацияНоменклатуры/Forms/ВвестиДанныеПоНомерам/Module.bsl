
&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	Для Каждого Строка Из СписокНоменклатуры Цикл
		СерияОбъект = Строка.СерияНоменклатуры.ПолучитьОбъект();
		Если СтарыйФормат Тогда
			СерияОбъект.КодГода = "";
			СерияОбъект.КодГрифа = "";
			СерияОбъект.КодДО = "";
			СерияОбъект.КодЦентра = "";
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СерияОбъект, Строка, "УчетныйНомер, ЗаводскойНомер, НомерМСИ");
		СерияОбъект.Записать();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьИЗакрытьНаСервере();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтотОбъект.ДокументПоступления = Параметры.ДокументПоступления;
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПоступлениеТоваровТовары.Номенклатура КАК Номенклатура,
	               |	ПоступлениеТоваровТовары.СерияНоменклатуры КАК СерияНоменклатуры,
	               |	ПоступлениеТоваровТовары.СерияНоменклатуры.УчетныйНомер КАК УчетныйНомер,
	               |	ПоступлениеТоваровТовары.СерияНоменклатуры.ЗаводскойНомер КАК ЗаводскойНомер,
	               |	ПоступлениеТоваровТовары.СерияНоменклатуры.НомерМСИ КАК НомерМСИ
	               |ИЗ
	               |	Документ.КомплектацияНоменклатуры.Товары КАК ПоступлениеТоваровТовары
	               |ГДЕ
	               |	НЕ ПоступлениеТоваровТовары.СерияНоменклатуры = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	               |	И ПоступлениеТоваровТовары.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.ДокументПоступления);
	
	СписокНоменклатуры.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьУчетныеНомера(Команда)
	ЗагрузитьНомера("УчетныйНомер");	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗаводскиеНомера(Команда)
	ЗагрузитьНомера("ЗаводскойНомер");	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНомераМСИ(Команда)
	ЗагрузитьНомера("НомерМСИ");
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНомера(Номер)
    Режим = РежимДиалогаВыбораФайла.Открытие;
    Диалог = Новый ДиалогВыбораФайла(Режим);
    Диалог.ПолноеИмяФайла = "";
    Диалог.МножественныйВыбор = Ложь;
	Фильтр = "Таблицы, *.xls*|*.xls*";
	Диалог.Фильтр = Фильтр;
    Диалог.Заголовок = "Укажите файл для чтения";
    Если Диалог.Выбрать() Тогда
        Файл = Диалог.ВыбранныеФайлы[0];
	Иначе
		Возврат;
    КонецЕсли;
    
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(Файл);
		ExcelЛист = Excel.Sheets(1);
	Исключение
		Excel = Неопределено;
		Сообщить("Ошибка обработки файла!");
		Возврат;
	КонецПопытки;
	
	Попытка
	
		Версия = Лев(Excel.Version,Найти(Excel.Version,".")-1);
		НачальнаяКолонка    = 1;
	    НачальнаяСтрока     = 1;
	    Если Версия = "8" Тогда
	        //КонечнаяКолонка = ExcelЛист.Cells.CurrentRegion.Columns.Count;
	        КонечнаяСтрока  = ExcelЛист.Cells.CurrentRegion.Rows.Count;
	    Иначе
	        //КонечнаяКолонка = ExcelЛист.Cells.SpecialCells(11).Column;
	        КонечнаяСтрока  = ExcelЛист.Cells.SpecialCells(11).Row;
		Конецесли;
		КонечнаяКолонка = 1;
		
		ДиапазонДанных = ExcelЛист.Range(ExcelЛист.Cells(НачальнаяСтрока, НачальнаяКолонка), ExcelЛист.Cells(КонечнаяСтрока, КонечнаяКолонка));
	    СтрокДиапазона = ДиапазонДанных.Rows.Count;
		
		ДиапазонДанных = ДиапазонДанных.Value;
		
		КоличествоЗаписей = ЭтотОбъект.СписокНоменклатуры.Количество();
		Для НомерСтроки = 1 По СтрокДиапазона Цикл
			УчетныйНомер = ДиапазонДанных.GetValue(1, НомерСтроки);
			Если НомерСтроки > КоличествоЗаписей Тогда
				Прервать;
			КонецЕсли;
			
			СписокНоменклатуры[НомерСтроки - 1][Номер] = СокрЛП(Формат(УчетныйНомер, "ЧГ="));
		КонецЦикла;
		
	Исключение
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		
	КонецПопытки;
	
	Excel.WorkBooks.Close();
	Excel = Неопределено;
КонецПроцедуры

