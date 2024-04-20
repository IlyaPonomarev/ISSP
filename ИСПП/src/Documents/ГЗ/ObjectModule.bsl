#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	Если ТипЗнч(ДанныеЗаполнения) = ТИП("ДокументСсылка.СпецификацияКДоговору") Тогда
		ЗаполнитьПоСпецификации(ДанныеЗаполнения);	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеПоддержкаПроектов.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеПоддержкаПроектов.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры



#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = Справочники.Валюты.НайтиПоКоду("840");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СуммаВВалюте) Тогда
		СуммаВВалюте = 50000;
	КонецЕсли;
	
	ЗаполнитьПоляПоУмолчанию();
	
КонецПроцедуры

Процедура ЗаполнитьПоляПоУмолчанию()
	
	Организация = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

//Процедура ЗаполнитьПоЗначениямАвтозаполнения()
//	
//	ОбщегоНазначенияПоддержкаПроектов.ЗаполнитьПоЗначениямАвтозаполнения(ЭтотОбъект, Неопределено, "Организация");
//	
//КонецПроцедуры
//
//Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
//	
//	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
//	
//КонецПроцедуры


Функция СписокРегистровДляКонтроля() Экспорт
	
	РегистрыДляКонтроля = Новый Массив;
		
	Возврат РегистрыДляКонтроля;
	
КонецФункции

Процедура ЗаполнитьПоСпецификации(Спецификация)

	СписокРеквизитов = "Организация, Валюта";

	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Спецификация, СписокРеквизитов);

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОснования);

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияКДоговоруТовары.Номенклатура,
	|	СпецификацияКДоговоруТовары.Количество
	|ИЗ
	|	Документ.СпецификацияКДоговору.Товары КАК СпецификацияКДоговоруТовары
	|ГДЕ
	|	СпецификацияКДоговоруТовары.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Спецификация);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПредметыПроекта.Добавить(), ВыборкаДетальныеЗаписи);
	КонецЦикла;

КонецПроцедуры
#КонецОбласти

#КонецЕсли