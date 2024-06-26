
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Добавляет механизм расширенного поиска на форму.
//
// Параметры:
//  Форма                     - УправляемаяФорма - форма для инициализации расширенного поиска.
//  ИмяГруппыРазмещенияПоиска - Строка - имя элемента формы типа Группа, где будут размещены элементы механизма расширенного поиска.
//  ИмяФильтруемогоСписка     - Строка - имя списка, в котором будет производиться поиск.
//  ИмяРеквизитаПоиска        - Строка - имя реквизита поиска.
//
Процедура ПриСозданииНаСервере(Форма, ИмяГруппыРазмещенияПоиска, ИмяФильтруемогоСписка, ИмяРеквизитаПоиска) Экспорт
	
	ИнициализироватьПоискВФорме(Форма, ИмяГруппыРазмещенияПоиска, ИмяФильтруемогоСписка, ИмяРеквизитаПоиска);
	
КонецПроцедуры

// Выполняет расширенный поиск в форме списка.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, где выполняется поиск.
//
// Возвращаемое значение:
//  ПоискВыполнен - Булево - признак того, что поиск был выполнен.
//
Функция ВыполнитьПоиск(Форма) Экспорт
	
	ПоискВыполнен = Ложь;
	
	Префикс = РасширенныйПоискВСпискахКлиентСервер.Префикс();
	
	РезультатПоиска = СтруктураРезультатовПоиска();
	СтрокаПоиска = РасширенныйПоискВСпискахКлиентСервер.СтрокаПоиска(Форма);
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		Если Не Форма[Префикс + "ИспользоватьПолнотекстовыйПоиск"] Тогда
			ВыполнитьНеПолнотекстовыйПоиск(Форма, РезультатПоиска);
		Иначе
			ВыполнитьПолнотекстовыйПоиск(Форма, РезультатПоиска);
		КонецЕсли;
		ПоискВыполнен = Истина;
		СохранитьИсториюПоиска(Форма);
	КонецЕсли;
	
	Форма[Префикс + "ПоискНеУдачный"] = (ПоискВыполнен И ЗначениеЗаполнено(РезультатПоиска.КодОшибки));
	Форма[Префикс + "КодОшибкиПоиска"] = РезультатПоиска.КодОшибки;
	
	РасширенныйПоискВСпискахКлиентСервер.УстановитьОтборСпискаПоСтрокеПоиска(Форма, РезультатПоиска.Элементы, ПоискВыполнен);
	
	Возврат ПоискВыполнен;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация
#Область Инициализация

Процедура ИнициализироватьПоискВФорме(Форма, ИмяГруппыРазмещенияПоиска, ИмяФильтруемогоСписка, ИмяРеквизитаПоиска)
	
	Описание = УправляемаяФорма.ПрочитатьОписаниеФормыИзСтроки(ОписаниеЭлементовФормы(ИмяГруппыРазмещенияПоиска));
	УправляемаяФорма.СоздатьЭлементы(Форма, Описание);
	
	Префикс = РасширенныйПоискВСпискахКлиентСервер.Префикс();
	Форма[Префикс + "ИмяФильтруемогоСписка"] = ИмяФильтруемогоСписка;
	Форма[Префикс + "ИмяФильтруемогоРеквизита"] = ИмяРеквизитаПоиска;
	ТипРеквизитаПоиска =
		Форма[ИмяФильтруемогоСписка].КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяРеквизитаПоиска)).ТипЗначения;
	Форма[Префикс + "ТипФильтруемогоРеквизита"] = ТипРеквизитаПоиска;
	
	ИспользоватьПолнотекстовыйПоиск = ПодборТоваровСервер.ИспользоватьПолнотекстовыйПоиск();
	Форма[Префикс + "ИспользоватьПолнотекстовыйПоиск"] = ИспользоватьПолнотекстовыйПоиск;
	
	Если ИспользоватьПолнотекстовыйПоиск Тогда
		ИндексПолнотекстовогоПоискаАктуален = ПолнотекстовыйПоискСервер.ИндексПоискаАктуален();
		Форма[Префикс + "ИндексПолнотекстовогоПоискаАктуален"] = ИндексПолнотекстовогоПоискаАктуален;
	КонецЕсли;
	
	СпискиВыбораКлиентСервер.Загрузить(РасширенныйПоискВСпискахКлиентСервер.КлючНастройки(Форма), РасширенныйПоискВСпискахКлиентСервер.СтрокаПоискаЭлементФормы(Форма).СписокВыбора);
	
КонецПроцедуры

Функция ОписаниеЭлементовФормы(ИмяГруппыДляРазмещения)
	
	Описание =
	"<Форма>
	|	<Реквизиты>
	|		<Реквизит Имя='%1ИспользоватьПолнотекстовыйПоиск'>
	|			<Типы>
	|				<Тип>Булево</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ИндексПолнотекстовогоПоискаАктуален'>
	|			<Типы>
	|				<Тип>Булево</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1НайтиПоТочномуСоответствию'>
	|			<Типы>
	|				<Тип>Булево</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ПоискНеУдачный'>
	|			<Типы>
	|				<Тип>Булево</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1КодОшибкиПоиска'>
	|			<Типы>
	|				<Тип>Строка</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1СтрокаПоиска'>
	|			<Типы>
	|				<Тип>Строка</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ИмяФильтруемогоСписка'>
	|			<Типы>
	|				<Тип>Строка</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ИмяФильтруемогоРеквизита'>
	|			<Типы>
	|				<Тип>Строка</Тип>
	|			</Типы>
	|		</Реквизит>
	|		<Реквизит Имя='%1ТипФильтруемогоРеквизита'>
	|			<Типы>
	|				<Тип>ОписаниеТипов</Тип>
	|			</Типы>
	|		</Реквизит>
	|	</Реквизиты>
	|	<Элементы>
	|		<УсловноеОформление>
	|			<Элемент>
	|				<Оформление ЦветФона='ПолеСОшибкойФон' />
	|				<Отбор>
	|					<Элемент ЛевоеЗначение='%1ПоискНеУдачный'><Значение Тип='Булево'>Истина</Значение></Элемент>
	|				</Отбор>
	|				<Поля>
	|					<Поле Имя='%1СтрокаПоиска' />
	|				</Поля>
	|			</Элемент>
	|		</УсловноеОформление>
	|		<ГруппаФормы Имя='%1ГруппаСтрокаПоиска' Родитель='%2'>
	|			<Свойство Имя='Вид'>ОбычнаяГруппа</Свойство>
	|			<Свойство Имя='ОтображатьЗаголовок'>Ложь</Свойство>
	|			<Свойство Имя='Отображение'>Нет</Свойство>
	|			<Свойство Имя='Группировка'>Горизонтальная</Свойство>
	|			<ПолеФормы Имя='%1СтрокаПоиска'>
	|					<Свойство Имя='ПутьКДанным'>%1СтрокаПоиска</Свойство>
	|					<Свойство Имя='Вид'>ПолеВвода</Свойство>
	|					<Свойство Имя='ПоложениеЗаголовка'>Нет</Свойство>
	|					<Свойство Имя='КнопкаВыпадающегоСписка'>Истина</Свойство>
	|					<Свойство Имя='КнопкаОчистки'>Истина</Свойство>
	|					<Свойство Имя='ПодсказкаВвода'>" + НСтр("ru='Введите текст для поиска'") + "</Свойство>
	|					<Свойство Имя='СочетаниеКлавиш'>Alt+_1</Свойство>
	|					<Свойство Имя='Ширина'>33</Свойство>
	|					<Свойство Имя='РастягиватьПоГоризонтали'>Ложь</Свойство>
	|				<События>
	|					<ПриИзменении Действие='Подключаемый_РасширенныйПоискВСписках_СтрокаПоискаПриИзменении' />
	|					<Очистка Действие='Подключаемый_РасширенныйПоискВСписках_СтрокаПоискаОчистка' />
	|				</События>
	|			</ПолеФормы>
	|			<ПолеФормы Имя='%1НайтиПоТочномуСоответствию'>
	|					<Свойство Имя='ПутьКДанным'>%1НайтиПоТочномуСоответствию</Свойство>
	|					<Свойство Имя='Вид'>ПолеФлажка</Свойство>
	|					<Свойство Имя='Заголовок'>" + НСтр("ru='По точному соответствию'") + "</Свойство>
	|					<Свойство Имя='ПоложениеЗаголовка'>Право</Свойство>
	|				<События>
	|					<ПриИзменении Действие='Подключаемый_РасширенныйПоискВСписках_НайтиПоТочномуСоответствиюПриИзменении' />
	|				</События>
	|			</ПолеФормы>
	|		</ГруппаФормы>
	|	</Элементы>
	|</Форма>
	|";
	
	Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Описание, РасширенныйПоискВСпискахКлиентСервер.Префикс(), ИмяГруппыДляРазмещения);
	Возврат Описание;
	
КонецФункции

#КонецОбласти // Инициализация

////////////////////////////////////////////////////////////////////////////////
// Полнотекстовый поиск
#Область ПолнотекстовыйПоиск

Процедура ВыполнитьПолнотекстовыйПоиск(Форма, РезультатПоиска)
	
	Префикс = РасширенныйПоискВСпискахКлиентСервер.Префикс();
	СтрокаПоиска = РасширенныйПоискВСпискахКлиентСервер.СтрокаПоиска(Форма);
	ТочноеСоответствие = Форма[Префикс + "НайтиПоТочномуСоответствию"];
	
	Если ТочноеСоответствие Тогда
		РасширеннаяСтрокаПоиска = """" + СтрокаПоиска + """";
	Иначе
		РасширеннаяСтрокаПоиска = ПолучитьРасширеннуюСтрокуПолнотекстовогоПоиска(СтрокаПоиска);
	КонецЕсли;
	
	РезультатПоиска = СтруктураРезультатовПоиска();
	МаксимальноеКоличествоЭлементовПоиска = МаксимальноеКоличествоЭлементовПоиска();
	
	Ссылка = Форма[Префикс + "ТипФильтруемогоРеквизита"].ПривестиЗначение();
	МенеджерПоиска = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
	ОбластиПоиска = ОбластиПоиска(МенеджерПоиска, Ссылка, Истина);
	
	// Создать список поиска.
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(РасширеннаяСтрокаПоиска);
	СписокПоиска.ПолучатьОписание = Ложь;
	СписокПоиска.ИспользованиеМетаданных = ИспользованиеМетаданныхПолнотекстовогоПоиска.НеИспользовать;
	СписокПоиска.ОбластьПоиска = ОбластиПоиска;
	
	Попытка
		СписокПоиска.ПерваяЧасть();
	Исключение
		РезультатПоиска.КодОшибки = "ОшибкаПоиска";
		Возврат;
	КонецПопытки;
	
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда
		РезультатПоиска.КодОшибки = "СлишкомМногоРезультатов";
		Возврат;
	КонецЕсли;
	
	КоличествоРезультатов = СписокПоиска.ПолноеКоличество();
	
	Если КоличествоРезультатов = 0 Тогда
		РезультатПоиска.КодОшибки = "НичегоНеНайдено";
		Возврат;
	КонецЕсли;
	
	Если КоличествоРезультатов > МаксимальноеКоличествоЭлементовПоиска Тогда
		РезультатПоиска.КодОшибки = "СлишкомМногоРезультатов";
		Возврат;
	КонецЕсли;
	
	// Пройти по списку поиска.
	РазмерПорции = 20;
	НачальнаяПозиция = 0;
	ВГраница = ?(КоличествоРезультатов > РазмерПорции, РазмерПорции, КоличествоРезультатов) - 1;
	
	НайденныеДанные = Новый Массив();
	ЕстьСледующаяПорция = Истина;
	Пока ЕстьСледующаяПорция Цикл
		Для Индекс = 0 По ВГраница Цикл
			НайденныеДанные.Добавить(СписокПоиска.Получить(Индекс));
		КонецЦикла;
		
		НачальнаяПозиция = НачальнаяПозиция + РазмерПорции;
		ЕстьСледующаяПорция = (НачальнаяПозиция < КоличествоРезультатов - 1);
		
		Если ЕстьСледующаяПорция Тогда
			ВГраница = ?(КоличествоРезультатов > (НачальнаяПозиция + РазмерПорции), РазмерПорции, КоличествоРезультатов - НачальнаяПозиция) - 1;
			СписокПоиска.СледующаяЧасть();
		КонецЕсли;
	КонецЦикла;
	
	РезультатПоиска.Элементы = ОбработатьНайденныеДанные(НайденныеДанные, МенеджерПоиска, Ссылка);
	Если РезультатПоиска.Элементы.Количество() = 0 Тогда
		РезультатПоиска.КодОшибки = "НичегоНеНайдено";
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьРасширеннуюСтрокуПолнотекстовогоПоиска(Знач СтрокаПоиска)
	
	Если СтрокаСодержитПоисковыеОператорыПолнотекстовогоПоиска(СтрокаПоиска) Тогда
		Возврат СтрокаПоиска;
	КонецЕсли;
	
	ДопустимыйПроцентОтличий = 20;
	МинимальнаяДлинаСловаДляПримененияЗаменыОкончания = 3;
	
	СловаПоиска = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаПоиска, " ");
	
	ПоискИзменен = Ложь;
	Для Индекс = 0 По СловаПоиска.Количество() - 1 Цикл
		
		Слово = СокрЛП(СловаПоиска[Индекс]);
		ДлинаСлова = СтрДлина(Слово);
		КритерийПоиска = "";
		
		КоличествоОтличий = Цел(ДлинаСлова * ДопустимыйПроцентОтличий / 100);
		Если КоличествоОтличий > 0 Тогда
			КритерийПоиска = КритерийПоиска + ?(ПустаяСтрока(КритерийПоиска), "", " | ") + Слово + "#" + КоличествоОтличий;
		КонецЕсли;
		
		ИспользоватьЗаменуОкончания = (ДлинаСлова >= МинимальнаяДлинаСловаДляПримененияЗаменыОкончания);
		Если ИспользоватьЗаменуОкончания Тогда
			КритерийПоиска = КритерийПоиска + ?(ПустаяСтрока(КритерийПоиска), "", " | ") + Слово + "*";
		КонецЕсли;
		
		Если Не ПустаяСтрока(КритерийПоиска) Тогда
			СловаПоиска[Индекс] = "(" + КритерийПоиска + ")";
			ПоискИзменен = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПоискИзменен Тогда
		СтрокаПоиска = СтрСоединить(СловаПоиска, " & ");
	КонецЕсли;
	
	Возврат СтрокаПоиска;
	
КонецФункции

Функция СтрокаСодержитПоисковыеОператорыПолнотекстовогоПоиска(Знач Строка)
	
	СлужебныеСимволы = """,&|?~/()*#!";
	Для Индекс = 1 По СтрДлина(СлужебныеСимволы) Цикл
		Символ = Сред(СлужебныеСимволы, Индекс, 1);
		Если Найти(Строка, Символ) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	СлужебныеСлова = Новый Массив;
	СлужебныеСлова.Добавить(" И ");
	СлужебныеСлова.Добавить(" AND ");
	СлужебныеСлова.Добавить(" ИЛИ ");
	СлужебныеСлова.Добавить(" OR ");
	СлужебныеСлова.Добавить(" НЕ ");
	СлужебныеСлова.Добавить(" NOT ");
	СлужебныеСлова.Добавить(" РЯДОМ");
	СлужебныеСлова.Добавить(" NEAR");
	Для каждого СлужебноеСлово Из СлужебныеСлова Цикл
		Если Найти(Строка, СлужебноеСлово) > 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти // ПолнотекстовыйПоиск

////////////////////////////////////////////////////////////////////////////////
// Не полнотекстовый поиск
#Область НеПолнотекстовыйПоиск

Процедура ВыполнитьНеПолнотекстовыйПоиск(Форма, РезультатПоиска)
	
	Префикс = РасширенныйПоискВСпискахКлиентСервер.Префикс();
	ТочноеСоответствие = Форма[Префикс + "НайтиПоТочномуСоответствию"];
	ИсходнаяСтрокаПоиска = РасширенныйПоискВСпискахКлиентСервер.СтрокаПоиска(Форма);
	
	Если ТочноеСоответствие Тогда
		СтрокаПоиска = "%" + ЭкранироватьСлужебныеСимволыЯзыкаЗапросов(ИсходнаяСтрокаПоиска, "\") + "%";
	Иначе
		СтрокаПоиска = ПолучитьРасширеннуюСтрокуПоискаЯзыкаЗапросов(ИсходнаяСтрокаПоиска, "\");
	КонецЕсли;
	
	Ссылка = Форма[Префикс + "ТипФильтруемогоРеквизита"].ПривестиЗначение();
	МенеджерПоиска = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
	ОбластиПоиска = ОбластиПоиска(МенеджерПоиска, Ссылка, Ложь);
	
	РазделительВТекстеЗапросов = Символы.ПС + ";" + Символы.ПС;
	
	ТекстЗапроса = "";
	Для Каждого ОбластьПоиска Из ОбластиПоиска Цикл
		ТекстЗапросаПоискаПоОбласти = ТекстЗапросаПоискаПоОбласти(ОбластьПоиска, МенеджерПоиска, Ссылка);
		ТекстЗапроса = ТекстЗапроса + ?(ЗначениеЗаполнено(ТекстЗапроса), РазделительВТекстеЗапросов, "") + ТекстЗапросаПоискаПоОбласти;
	КонецЦикла;
	
	МаксимальноеКоличествоЭлементовПоиска = МаксимальноеКоличествоЭлементовПоиска();
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%МаксимальноеКоличество%", МаксимальноеКоличествоЭлементовПоиска);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ВидСравнения%", "ПОДОБНО");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Спецсимвол%", "СПЕЦСИМВОЛ ""\""");
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("СтрокаПоиска", СтрокаПоиска);
	Запрос.УстановитьПараметр("ИсходнаяСтрокаПоиска", ИсходнаяСтрокаПоиска);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	НайденныеДанные = Новый Массив;
	Для Каждого РезультатЗапроса Из РезультатыЗапроса Цикл
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЭлементПоиска = Новый Структура("Значение, Метаданные");
			ЗаполнитьЗначенияСвойств(ЭлементПоиска, Выборка);
			
			НайденныеДанные.Добавить(ЭлементПоиска);
			
			Если НайденныеДанные.Количество() > МаксимальноеКоличествоЭлементовПоиска Тогда
				РезультатПоиска.КодОшибки = "СлишкомМногоРезультатов";
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	РезультатПоиска.Элементы = ОбработатьНайденныеДанные(НайденныеДанные, МенеджерПоиска, Ссылка);
	Если РезультатПоиска.Элементы.Количество() = 0 Тогда
		РезультатПоиска.КодОшибки = "НичегоНеНайдено";
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьРасширеннуюСтрокуПоискаЯзыкаЗапросов(Знач СтрокаПоиска, Знач Спецсимвол = "\")
	
	Если СтрокаСодержитСлужебныеСимволыЯзыкаЗапросов(СтрокаПоиска) Тогда
		
		РасширеннаяСтрокаПоиска = СтрокаПоиска;
		Если Лев(РасширеннаяСтрокаПоиска, 1) <> "%" Тогда
			РасширеннаяСтрокаПоиска = "%" + РасширеннаяСтрокаПоиска;
		КонецЕсли;
		
		Если Прав(РасширеннаяСтрокаПоиска, 1) <> "%" Тогда
			РасширеннаяСтрокаПоиска = РасширеннаяСтрокаПоиска + "%";
		КонецЕсли;
		
	Иначе
		
		СловаПоиска = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаПоиска, " ");
		
		РасширеннаяСтрокаПоиска = "";
		Для Каждого Слово Из СловаПоиска Цикл
			Если Не ПустаяСтрока(Слово) Тогда
				РасширеннаяСтрокаПоиска = РасширеннаяСтрокаПоиска + " %" + Слово + "%";
			КонецЕсли;
		КонецЦикла;
		РасширеннаяСтрокаПоиска = СокрЛП(РасширеннаяСтрокаПоиска);
		
	КонецЕсли;
	
	РасширеннаяСтрокаПоиска = СтрЗаменить(РасширеннаяСтрокаПоиска, Спецсимвол, Спецсимвол + Спецсимвол);
	
	Возврат РасширеннаяСтрокаПоиска;
	
КонецФункции

Функция СтрокаСодержитСлужебныеСимволыЯзыкаЗапросов(Знач Строка)
	
	СлужебныеСимволы = "%_[]";
	Для Индекс = 1 По СтрДлина(СлужебныеСимволы) Цикл
		Символ = Сред(СлужебныеСимволы, Индекс, 1);
		Если Найти(Строка, Символ) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭкранироватьСлужебныеСимволыЯзыкаЗапросов(Знач Параметр, Знач Спецсимвол = "\")
	
	Результат = СтрЗаменить(Параметр, Спецсимвол, Спецсимвол + Спецсимвол);
	Результат = СтрЗаменить(Результат, "%", Спецсимвол + "%");
	Результат = СтрЗаменить(Результат, "_", Спецсимвол + "_");
	Результат = СтрЗаменить(Результат, "[", Спецсимвол + "[");
	Результат = СтрЗаменить(Результат, "]", Спецсимвол + "]");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти // НеПолнотекстовыйПоиск

////////////////////////////////////////////////////////////////////////////////
// Прочее
#Область Прочее

Функция ОбластиПоиска(МенеджерПоиска, Ссылка, ПолнотекстовыйПоиск)
	
	Результат = ОбщегоНазначенияПоддержкаПроектов.ВыполнитьНеобязательныйМетодОбъекта(
		МенеджерПоиска, "ОбластиПоиска", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПолнотекстовыйПоиск), Истина);
	Если Результат = Неопределено Тогда
		Результат = ОбластиПоискаПоУмолчанию(Ссылка, ПолнотекстовыйПоиск);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОбластиПоискаПоУмолчанию(Ссылка, ПолнотекстовыйПоиск)
	
	МетаданныеОбъекта = Ссылка.Метаданные();
	
	ОбластиПоиска = Новый Массив;
	ОбластиПоиска.Добавить(МетаданныеОбъекта);
	
	Если Не ПолнотекстовыйПоиск Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
			Свойства = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
			Если Свойства.ИспользоватьДопРеквизиты(Ссылка) Тогда
				ОбластиПоиска.Добавить(Метаданные.ПланыВидовХарактеристик["ДополнительныеРеквизитыИСведения"]);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОбластиПоиска;
	
КонецФункции

Функция ТекстЗапросаПоискаПоОбласти(ОбластьПоиска, МенеджерПоиска, Ссылка)
	
	ТекстЗапроса = ОбщегоНазначенияПоддержкаПроектов.ВыполнитьНеобязательныйМетодОбъекта(
		МенеджерПоиска, "ТекстЗапросаПоискаПоОбласти", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбластьПоиска), Истина);
	
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат ТекстЗапроса;
	КонецЕсли;
	
	МетаданныеОбъекта = Ссылка.Метаданные();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства")
	   И ОбластьПоиска = Метаданные.ПланыВидовХарактеристик["ДополнительныеРеквизитыИСведения"] Тогда
		Возврат "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ %МаксимальноеКоличество%
		|	ДополнительныеРеквизиты.Ссылка КАК Значение,
		|	""" + МетаданныеОбъекта.Имя + """ КАК Метаданные
		|ИЗ
		|	" + МетаданныеОбъекта.ПолноеИмя() + ".ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Значение %ВидСравнения% &СтрокаПоиска %Спецсимвол%
		|	ИЛИ ДополнительныеРеквизиты.ТекстоваяСтрока %ВидСравнения% &СтрокаПоиска %Спецсимвол%
		|";
	КонецЕсли;
	
	ПоляДляПоиска = Новый Массив;
	Если ОбщегоНазначения.ЭтоСправочник(ОбластьПоиска)
	 Или ОбщегоНазначения.ЭтоПланВидовХарактеристик(ОбластьПоиска)
	 ИЛИ ОбщегоНазначения.ЭтоПланВидовРасчета(ОбластьПоиска)
	 ИЛИ ОбщегоНазначения.ЭтоПланОбмена(ОбластьПоиска)
	 ИЛИ ОбщегоНазначения.ЭтоПланСчетов(ОбластьПоиска) Тогда
		Если ОбластьПоиска.ДлинаКода > 0 Тогда
			ПоляДляПоиска.Добавить("Код");
		КонецЕсли;
		Если ОбластьПоиска.ДлинаНаименования > 0 Тогда
			ПоляДляПоиска.Добавить("Наименование")
		КонецЕсли;
		Если ОбластьПоиска.Реквизиты.Найти("НаименованиеПолное") <> Неопределено Тогда
			ПоляДляПоиска.Добавить("");
		КонецЕсли;
	КонецЕсли;
	
	Если ПоляДляПоиска.Количество() = 0 Тогда
		ОписаниеОшибки = НСтр("ru='Неизвестная область поиска: ""%ОбластьПоиска%""'");
		ВызватьИсключение СтрЗаменить(ОписаниеОшибки, "%ОбластьПоиска%", СокрЛП(ОбластьПоиска));
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ %МаксимальноеКоличество%
	|	Объект.Ссылка КАК Значение,
	|	""" + ОбластьПоиска.Имя + """ КАК Метаданные
	|ИЗ
	|	" + ОбластьПоиска.ПолноеИмя() + " КАК Объект
	|ГДЕ
	|";
	ТекстУсловия = "";
	Для Каждого Поле Из ПоляДляПоиска Цикл
		ТекстУсловия = ТекстУсловия + "
		|	" + ?(ПустаяСтрока(ТекстУсловия), "", "ИЛИ ") + "Объект." + Поле + " %ВидСравнения% &СтрокаПоиска %Спецсимвол%
		|";
	КонецЦикла;
	ТекстЗапроса = ТекстЗапроса + ТекстУсловия;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ОбработатьНайденныеДанные(НайденныеДанные, МенеджерПоиска, Ссылка)
	
	Объекты = ОбщегоНазначенияПоддержкаПроектов.ВыполнитьНеобязательныйМетодОбъекта(
		МенеджерПоиска, "ОбработатьНайденныеДанные", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НайденныеДанные), Истина);
	
	Если Объекты <> Неопределено Тогда
		Возврат Объекты;
	КонецЕсли;
	
	ТипСсылки = ТипЗнч(Ссылка);
	Объекты = Новый Массив;
	Для Каждого Элемент Из НайденныеДанные Цикл
		Если ТипЗнч(Элемент.Значение) = ТипСсылки Тогда
			Объекты.Добавить(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Объекты;
	
КонецФункции

Функция СтруктураРезультатовПоиска()
	
	РезультатПоиска = Новый Структура;
	РезультатПоиска.Вставить("КодОшибки", "");
	РезультатПоиска.Вставить("Элементы", Новый Массив);
	
	Возврат РезультатПоиска;
	
КонецФункции

Функция МаксимальноеКоличествоЭлементовПоиска()
	
	Возврат 500;
	
КонецФункции

Процедура СохранитьИсториюПоиска(Форма)
	
	КоличествоСохраняемыхЭлементов = 21;
	
	СтрокаПоиска = РасширенныйПоискВСпискахКлиентСервер.СтрокаПоиска(Форма);
	СписокВыбора = РасширенныйПоискВСпискахКлиентСервер.СтрокаПоискаЭлементФормы(Форма).СписокВыбора;
	
	ЭлементСписка = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	Если ЭлементСписка = Неопределено Или СписокВыбора.Индекс(ЭлементСписка) > 0 Тогда
		СпискиВыбораКлиентСервер.ОбновитьСписокВыбора(СписокВыбора, СтрокаПоиска, КоличествоСохраняемыхЭлементов);
		СпискиВыбораКлиентСервер.Сохранить(
			РасширенныйПоискВСпискахКлиентСервер.КлючНастройки(Форма),
			СписокВыбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // Прочее

#КонецОбласти // СлужебныеПроцедурыИФункции
