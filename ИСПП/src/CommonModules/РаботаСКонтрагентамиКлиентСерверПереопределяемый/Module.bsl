#Область ПрограммныйИнтерфейс

#Область ПроверкаКонтрагентовВДокументах

// Определение вида документа.
//
// Параметры:
//  Форма								 - УправляемаяФорма - Форма документа, для которого необходимо получить описание.
//	Результат							 - Структура - Описывает вид документа. Ключи:
//  		"КонтрагентНаходитсяВШапке"			 	- Булево - Признак того, есть у документа контрагент в шапке
//  		"КонтрагентНаходитсяВТабличнойЧасти"	- Булево - Признак того, есть у документа контрагенты в табличных частях
//  		"СчетФактураНаходитсяВПодвале"		 	- Булево - Признак того, есть у документа счет-фактура в подвале
//  		"ЯвляетсяСчетомФактурой"				- Булево - Признак того, является ли сам документ счетом-фактурой.
Процедура ОпределитьВидДокумента(Форма, Результат) Экспорт
	
	// ПоддержкаПроектов
	
	ТипСсылки = ТипЗнч(Форма.Объект.Ссылка);
	Если ТипСсылки = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		
		Результат.Вставить("КонтрагентНаходитсяВШапке", Истина);
		
	ИначеЕсли ТипСсылки = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		Результат.Вставить("КонтрагентНаходитсяВШапке", Истина);
		
	КонецЕсли;
	
	// Конец ПоддержкаПроектов
	
КонецПроцедуры

// Получение счета-фактуры, находящегося в подвале документа-основания, чья форма передана в качестве
//             параметра.
//
// Параметры:
//  Форма		 - УправляемаяФорма - Форма документа-основания, для которой необходимо получить счет-фактуру.
//  СчетФактура	 - ДокументСсылка - Счет-фактура, полученная для данного документа-основания.
Процедура ПолучитьСчетФактуру(Форма, СчетФактура) Экспорт
	
	
КонецПроцедуры

// Возможность доопределить сформированную подсказку для формы документа.
//
// Параметры:
//  Результат            - Структура - содержит текст подсказки и цвет фона подсказки.
//  СостояниеКонтрагента - ПеречислениеСсылка.СостоянияСуществованияКонтрагента - текущее состояние контрагента.
//  Цвета                - Структура - содержит цвета, используемые при выводе информации о состоянии контрагента.
//
Процедура ПослеФормированияПодсказкиВДокументе(Результат, СостояниеКонтрагента, Цвета) Экспорт
	
	
	
КонецПроцедуры 

#КонецОбласти

#Область ПроверкаКонтрагентовВОтчетах

// Вывод панели проверки в отчете.
//
// Параметры:
//  Форма	 				- УправляемаяФорма - Форма отчета, для которого выводится результат проверки контрагента.
//  СостояниеПроверки		- Строка - Текущее состояние проверки, может принимать следующие значения, либо быть пустой
//                                строкой: ВсеКонтрагентыКорректные
// 			НайденыНекорректныеКонтрагенты
// 			ДопИнформацияПоПроверке
// 			ПроверкаВПроцессеВыполнения
// 			НетДоступаКСервису.
//  СтандартнаяОбработка	- Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                  процедуре.
Процедура УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, СтандартнаяОбработка, СостояниеПроверки = "") Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВСправочнике

// Отображение результата проверки контрагента в справочнике.
// Реализация тела метода является обязательной.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  ПредставлениеРезультатаПроверки	 - ФорматированнаяСтрока, Строка - представление результата проверки
//  					контрагента.
//
Процедура ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма, ПредставлениеРезультатаПроверки) Экспорт
	
	// ПоддержкаПроектов
	ПроверкаКонтрагентовПоддержкаПроектовКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма, ПредставлениеРезультатаПроверки);
	// Конец ПоддержкаПроектов
	
КонецПроцедуры

// Определяет строковое представление результата проверки контрагента.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма справочника, в котором выполнялась проверка контрагента.
//  	Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы контрагента.
//  	Структуру полей РеквизитыПроверкиКонтрагентов см. в процедуре ИнициализироватьРеквизитыФормыКонтрагент ОМ
//  	ПроверкаКонтрагентов.
//  Текст - Строка - представление результата проверки контрагента.
//
Процедура ПриЗаполненииТекстаРезультатаПроверки(Форма, Текст) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедуры

// Возможность дополнить параметры запуска фонового задания при проверке справочника.
//
// Параметры:
//  ДополнительныеПараметрыЗапуска - Структура - содержит параметры запуска.
//  Форма                          - УправляемаяФорма - форма, из которой запускается фоновое задание.
//
Процедура ДополнитьПараметрыЗапускаФоновогоЗадания(ДополнительныеПараметрыЗапуска, Форма) Экспорт
	
	
КонецПроцедуры

// Получение объекта (ДанныеФормыСтруктура) и ссылки(ДокументСсылка, СправочникСсылка) документа или
// справочника,  в котором выполняется проверка контрагента, по форме.
// Обязательна к заполнению.
//
// Параметры:
//	Форма     - УправляемаяФорма - Форма документа или справочника, в котором выполняется проверка контрагента.
//	Результат - Структура - Объект и Ссылка, полученные по форме документа.
//		Ключи: "Объект" (Тип ДанныеФормыСтруктура) и "Ссылка" (Тип ДокументСсылка, СправочникСсылка).
//
Процедура ПриОпределенииОбъектаИСсылкиПоФорме(Форма, Результат) Экспорт
	
	// ПоддержкаПроектов
	Объект = Форма.Объект;
	Результат.Объект = Объект;
	Результат.Ссылка = Объект.Ссылка;
	// Конец ПоддержкаПроектов
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
