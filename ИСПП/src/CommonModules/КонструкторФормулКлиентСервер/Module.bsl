
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Получает текст операнда для вставки в формулу
//
// Параметры:
// Операнд - Строка - имя операнда
//
// Возвращаемое значение:
// Строка
//
Функция ПолучитьТекстОперандаДляВставки(Операнд) Экспорт
	
	Возврат "[" + Операнд + "]";
	
КонецФункции

// Осуществляет проверку корректности формулы
//
// Параметры:
// 	Формула - Строка - текст формулы
//	ДоступныеОперанды - Соответствие - Ключ - операнд, Значение - ОписаниеТипов
// 	ТекстОшибки- Строка - текст сообщения об ошибке
//
// Возвращаемое значение:
// 	Булево - Ложь, если есть ошибки, иначе Истина
//
Функция ПроверитьФормулу(Формула, Знач Операнды = Неопределено, ТекстОшибки = "") Экспорт
	
	Результат = Истина;
	Если Операнды = Неопределено Тогда
		Операнды = ПолучитьОперандыФормулы(Формула);
	КонецЕсли;
	
	Если ТипЗнч(Операнды) = Тип("Соответствие") Тогда
		ДоступныеОперанды = Операнды;
	ИначеЕсли ТипЗнч(Операнды) = Тип("Массив") Тогда
		
		ДоступныеОперанды = Новый Соответствие;
		Для каждого Операнд Из Операнды Цикл
			ДоступныеОперанды.Вставить(Операнд, Новый ОписаниеТипов("Число"));
		КонецЦикла;
	Иначе
		ВызватьИсключение НСтр("ru='Некорректный параметр ""Операнды"" в функции ""ПроверитьФормулу"".'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Формула) Тогда
		
		ТекстРасчета = Формула;
		
		Для Каждого ОписаниеОперанда Из ДоступныеОперанды Цикл
			Операнд = ОписаниеОперанда.Ключ;
			ТипОперанда = ОписаниеОперанда.Значение;
			Если ТипОперанда = Неопределено Тогда
				ЗначениеЗамены = """Строка1""";
			Иначе
				Если ТипОперанда.СодержитТип(Тип("Число")) Тогда
					ЗначениеЗамены = "Число(1)";
				ИначеЕсли ТипОперанда.СодержитТип(Тип("Дата")) Тогда
					ЗначениеЗамены = "'0001.01.01'";
				Иначе
					ЗначениеЗамены = """Строка1""";
				КонецЕсли;
			КонецЕсли;
			ТекстРасчета = СтрЗаменить(ТекстРасчета, ПолучитьТекстОперандаДляВставки(Операнд), ЗначениеЗамены);
		КонецЦикла;
		
		Попытка
			
			#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
				РезультатРасчета = ОбщегоНазначения.ВычислитьВБезопасномРежиме(ТекстРасчета);
			#Иначе
				РезультатРасчета = Вычислить(ТекстРасчета);
			#КонецЕсли
			
			ТекстПроверки = СтрЗаменить(Формула, Символы.ПС, "");
			ТекстПроверки = СтрЗаменить(ТекстПроверки, " ", "");
			ОтсутствиеРазделителей = СтрНайти(ТекстПроверки, "][") + СтрНайти(ТекстПроверки, """[") + СтрНайти(ТекстПроверки, "]""");
			Если ОтсутствиеРазделителей > 0 Тогда
				ТекстОшибки = НСтр("ru = 'В формуле обнаружены ошибки. Между операндами должен присутствовать оператор или разделитель'");
				Результат = Ложь;
			КонецЕсли;
			
		Исключение
			ТекстОшибки =
				НСтр("ru = 'В формуле обнаружены ошибки. Проверьте формулу. Формулы должны составляться по правилам написания выражений на встроенном языке 1С:Предприятия.'")
				+ КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Результат = Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Извлекает операнды из формулы
//
// Параметры:
// 	Формула - Строка - текст формулы
//
// Возвращаемое значение:
// 	Массив - Операнды из текстовой формулы
//
Функция ПолучитьОперандыФормулы(Формула) Экспорт
	
	Операнды = Новый Массив();
	
	ТекстФормулы = СокрЛП(Формула);
	
	ЕстьОперанды = (СтрЧислоВхождений(ТекстФормулы, "[") = СтрЧислоВхождений(ТекстФормулы, "]"));
	Пока ЕстьОперанды Цикл
		НачалоОперанда = Найти(ТекстФормулы, "[");
		КонецОперанда = Найти(ТекстФормулы, "]");
		
		Если НачалоОперанда = 0
		 Или КонецОперанда = 0
		 Или НачалоОперанда > КонецОперанда Тогда
			
			ЕстьОперанды = Ложь;
			Прервать;
			
		КонецЕсли;
		
		ИмяОперанда = Сред(ТекстФормулы, НачалоОперанда + 1, КонецОперанда - НачалоОперанда - 1);
		Операнды.Добавить(ИмяОперанда);
		ТекстФормулы = СтрЗаменить(ТекстФормулы, "[" + ИмяОперанда + "]", "");
		
	КонецЦикла;
	
	Возврат Операнды
	
КонецФункции

// Подставляет значения операндов в формулу и вычисляет ее
//
// Параметры:
//  Формула - Строка
//  ЗначенияОперандов - Соответствие
//
// Возвращаемое значение:
//  Произвольный - результат вычисления формулы.
//
Функция ВычислитьФормулу(Формула, ЗначенияОперандов) Экспорт
	
	ТекстРасчета = Формула;
	
	Индекс = 0;
	Параметры = Новый Массив;
	
	Операнды = ПолучитьОперандыФормулы(Формула);
	Для каждого Операнд Из Операнды Цикл
		ТекстРасчета = СтрЗаменить(ТекстРасчета, ПолучитьТекстОперандаДляВставки(Операнд), "Параметры[" + Индекс + "]");
		Параметры.Добавить(ЗначенияОперандов[Операнд]);
		Индекс = Индекс + 1;
	КонецЦикла;
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		РезультатРасчета = ОбщегоНазначения.ВычислитьВБезопасномРежиме(ТекстРасчета, Параметры);
	#Иначе
		РезультатРасчета = Вычислить(ТекстРасчета);
	#КонецЕсли
	
	Возврат РезультатРасчета;
	
КонецФункции

// Возвращает результат вычисления формулы с промежуточным результатом
//
// Параметры:
//  Формула - Строка - расчетная формула
//  ЗначенияОперандов - ТаблицаЗначений - значения операндов формулы
//       *Идентификатор - Строка
//       *Значение      - Произвольный
//  ВключатьФормулуВПредставление - Булево - Если Истина, то в представление будет включена формула
//
// Возвращаемое значение:
//  Строка
//
Функция ПолучитьПредставлениеВычисленияПоФормуле(Формула, ЗначенияОперандов, ВключатьФормулуВПредставление = Ложь) Экспорт
	
	РасчетнаяФормула = Формула;
	Если Не ЗначениеЗаполнено(РасчетнаяФормула) Тогда
		Возврат "";
	КонецЕсли;
	
	ТипыОперандов = Новый Соответствие;
	
	ВыводитьПромежуточныеВычисления = Ложь;
	
	ОперандыФормулы = КонструкторФормулКлиентСервер.ПолучитьОперандыФормулы(РасчетнаяФормула);
	Для Каждого Операнд Из ОперандыФормулы Цикл
		ТипОперанда = Неопределено;
		НайденныйСтроки = ЗначенияОперандов.НайтиСтроки(Новый Структура("Идентификатор", Операнд));
		Если НайденныйСтроки.Количество() = 1 Тогда
			Если Не ВыводитьПромежуточныеВычисления Тогда
				ВыводитьПромежуточныеВычисления = Не ПустаяСтрока(СтрЗаменить(РасчетнаяФормула, "[" + Операнд + "]", ""));
			КонецЕсли;
			ЗначениеОперанда = НайденныйСтроки[0].Значение;
			РасчетнаяФормула = СтрЗаменить(РасчетнаяФормула, "[" + Операнд + "]", Формат(ЗначениеОперанда, "ЧРД=.; ЧН=0; ЧГ=0"));
			ТипОперанда = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(ЗначениеОперанда)));
		КонецЕсли;
		ТипыОперандов.Вставить(Операнд, ТипОперанда);
	КонецЦикла;
	
	Если Не ПроверитьФормулу(Формула, ТипыОперандов) Тогда
		Возврат НСтр("ru = '= ошибка расчета'");
	КонецЕсли;
	
	РезультатВычисления = Формат(Вычислить(РасчетнаяФормула),"ЧЦ=15; ЧДЦ=3; ЧН=0");
	
	Представление = ?(ВыводитьПромежуточныеВычисления, РасчетнаяФормула, "") + ?(ЗначениеЗаполнено(РасчетнаяФормула), " = ", "") + РезультатВычисления;
	Если ВключатьФормулуВПредставление Тогда
		Представление = Формула + " = " + Представление;
	КонецЕсли;
	
	Возврат УдалитьНезначимыеСимволы(Представление);
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

Функция УдалитьНезначимыеСимволы(Знач ВходящаяСтрока)
	
	ВходящаяСтрока = СокрЛП(ВходящаяСтрока);
	ДлинаСтроки = СтрДлина(ВходящаяСтрока);
	КонечнаяСтрока = Строка("");
	
	Пока ДлинаСтроки > 0 Цикл
		
		ПервыйСимвол = Лев(ВходящаяСтрока, 1);
		
		Если Не ПустаяСтрока(ПервыйСимвол) Тогда
			КонечнаяСтрока = КонечнаяСтрока + ПервыйСимвол;
			ВходящаяСтрока = Сред(ВходящаяСтрока, 2);
			ДлинаСтроки = ДлинаСтроки - 1;
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + " ";
			ВходящаяСтрока = СокрЛ(ВходящаяСтрока);
			ДлинаСтроки = СтрДлина(ВходящаяСтрока);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КонечнаяСтрока;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
