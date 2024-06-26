
// Обработка заполнения.
// 
// Параметры:
//  ДанныеЗаполнения - ДокументСсылка.ПоступлениеТоваров - Данные заполнения
//  СтандартнаяОбработка - Строка, Неопределено - Стандартная обработка
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		
		Организация = ДанныеЗаполнения.Организация;
		Ответственный = Пользователи.ТекущийПользователь();
		Склад = ДанныеЗаполнения.Склад;
		Гриф = ДанныеЗаполнения.Гриф;
		ПроектЗадания = ДанныеЗаполнения.ПроектЗадания;

		ДокументОснование = ДанныеЗаполнения;	
		
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.КоличествоВсего = ТекСтрокаТовары.Количество;
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.СерияНоменклатуры = ТекСтрокаТовары.СерияНоменклатуры;
			НоваяСтрока.НомерПоПеречню = ОпределитьНомерПоПеречню(ДанныеЗаполнения.ЗаказПоставщику, НоваяСтрока.Номенклатура);
			НоваяСтрока.Партия = ПолучитьПартиюПоДаннымЗаполнения(ДанныеЗаполнения);
			НоваяСтрока.СтатусУказанияСерий = ТекСтрокаТовары.СтатусУказанияСерий;
			НоваяСтрока.СтатусУказанияПартий = 4;
			НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция ОпределитьНомерПоПеречню(СпецификацияКДоговору, Номенклатура)

	Для Каждого СтрокаТовар Из СпецификацияКДоговору.Товары Цикл
		Если СтрокаТовар.Номенклатура = Номенклатура Тогда
			Возврат СтрокаТовар.НомерСТроки;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
КонецФункции	

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеПоддержкаПроектов.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		Ответственный = Пользователи.АвторизованныйПользователь();
	КонецЕсли;	

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтруктураОтбора = Новый Структура("СтатусУказанияСерий", 6);
	СтрокиССериями = Товары.НайтиСтроки(СтруктураОтбора);
	НоменклатураПоСериям = Товары.Выгрузить(СтрокиССериями);
	НоменклатураПоСериям.Свернуть("Номенклатура, СерияНоменклатуры", "Количество");
	Для Каждого Строка Из НоменклатураПоСериям Цикл
		Если Строка.Количество > 1 И Строка.Номенклатура.ВидНоменклатуры.НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для нескольких строк с номенклатурой '" + Строка(Строка.Номенклатура) + "' указана одна и та же серия '" + Строка(Строка.СерияНоменклатуры) + "'.");
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
	
КонецПроцедуры

Функция ПолучитьПартиюПоДаннымЗаполнения(ДанныеЗаполнения)

	Возврат Справочники.ПартииНоменклатуры.НайтиПоРеквизиту("ДокументОприходования", ДанныеЗаполнения);

КонецФункции	

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеПоддержкаПроектов.СформироватьДвиженияПоРегистрам(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Функция СписокРегистровДляКонтроля() Экспорт
	
	РегистрыДляКонтроля = Новый Массив;
	
	Возврат РегистрыДляКонтроля;
	
КонецФункции