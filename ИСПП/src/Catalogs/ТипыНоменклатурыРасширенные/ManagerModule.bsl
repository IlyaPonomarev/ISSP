#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает подсказку по типу номенклатуры
//
// Параметры:
//  ТипНоменклатуры - СправочникСсылка.ТипыНоменклатурыРасширенные - значение, по которому получается подсказка
//
// Возвращаемое значение:
//  Подсказка - Строка - подсказка, полученная по типу номенклатуры
//
Функция ПодсказкаПоТипуНоменклатуры(ТипНоменклатуры) Экспорт
	
	Если ТипНоменклатуры = Справочники.ТипыНоменклатурыРасширенные.Товар Тогда
		Подсказка = НСтр("ru = 'Материальные ценности, которые закупаются, производятся, реализуются предприятием и учитываются на складах. Возможен как контроль остатков на складах, учет себестоимости и др.'");
	ИначеЕсли ТипНоменклатуры = Справочники.ТипыНоменклатурыРасширенные.Услуга Тогда
		Подсказка = НСтр("ru = 'Нематериальные ценности, которые закупаются предприятием или реализуются клиентам. Для услуг не ведется учет себестоимости. В момент приобретения услуги указывается статья расходов, определяющая дальнейший учет расходов.'");
	Иначе
		Подсказка = НСтр("ru = 'Определяет возможности по учету номенклатуры в различных механизмах'");
	КонецЕсли;
	
	Возврат Подсказка;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ
#Область ОбновлениеИнформационнойБазы

// Обработчик обновления информационной базы,
// предназначенный для первоначального заполнения
// предопределенных данных.
//
Процедура ЗаполнитьПервоначальныеДанные() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект = Товар.ПолучитьОбъект();
	Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар;
	Объект.Записать();
	
	Объект = Услуга.ПолучитьОбъект();
	Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга;
	Объект.Записать();
	
КонецПроцедуры

#КонецОбласти // ОбновлениеИнформационнойБазы

#КонецЕсли