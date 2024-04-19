#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область СлужебныйПрограммныйИнтерфейс

// Вызывает модуль менеджера отчета для заполнения его настроек.
//   Для вызова из процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из процедуры НастроитьВариантыОтчетов.
//   ОтчетМетаданные - ОбъектМетаданных - Метаданные отчета.
//
// Важно:
//   Для использования в модуле менеджера отчета должна быть размещена экспортная процедура по шаблону:
//      // Настройки размещения в панели отчетов.
//      //
//      // Параметры:
//      //   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//      //   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//      //       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//      //       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Описание:
//      //   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//      //
//      // Вспомогательные методы:
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//      //
//      // Примеры:
//      //
//      //  1. Установка описания варианта.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Описание = НСтр("ru = '<Описание>'");
//      //
//      //  2. Отключение варианта отчета.
//      //	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//      //	НастройкиВарианта.Включен = Ложь;
//      //
//      Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
//      	// Код процедуры.
//      КонецПроцедуры
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.Включен = Ложь;
	
КонецПроцедуры

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ТоварыКОформлениюИзлишковНедостач) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер      = Метаданные.Отчеты.ТоварыКОформлениюИзлишковНедостач.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Оформление'");
		КомандаОтчет.Важность      = МенюОтчетыПоддержкаПроектов.ПодменюОтчетыВажное();
		КомандаОтчет.КлючВарианта  = "ТоварыКОформлениюИзлишковНедостач";
		КомандаОтчет.ИмяПараметраФормы  = "Отбор.ПараметрКоманды";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#КонецЕсли