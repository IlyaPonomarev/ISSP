
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает описание доступных печатных форм
//
// Параметры:
//  ИмяМенеджераПечати - Строка - полное имя объекта печати.
//
// Возвращаемое значение:
//  ТаблицаЗначений - см. УправлениеПечатьюБА.СоздатьКоллекциюДоступныхПечатныхФорм.
//
Функция ДоступныеПечатныеФормы(ИмяМенеджераПечати) Экспорт
	
	МенеджерПечати = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяМенеджераПечати);
	Возврат МенеджерПечати.ДоступныеПечатныеФормы();
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс
