
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеФормы();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", Элементы.ГруппаДополнительныеРеквизиты.Имя);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	НастроитьОтображениеВидаНоменклатуры();
	НастроитьВозможностьДобавленияУпаковок();
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ПриСозданииНовогоПриЧтенииНаСервере();
		ЕстьПравоРедактирования = Истина;
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовНоменклатуры") И Объект.ВидНоменклатуры.Пустая() Тогда
			Объект.ВидНоменклатуры = Элементы.ВидНоменклатурыПереключатель.СписокВыбора[0].Значение;
			ОбработатьИзменениеВидаНоменклатуры();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ФайлКартинки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования, "ФайлКартинки");
			Если ЗначениеЗаполнено(ФайлКартинки) Тогда
				СкопироватьПрисоединенныйФайлКартинки(ФайлКартинки);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ЕстьПравоРедактирования               = Справочники.ГруппыДоступаНоменклатуры.ЕстьПравоИзменения(Объект);
		ЭтотОбъект.ТолькоПросмотр             = Не ЕстьПравоРедактирования;
		Элементы.АдресКартинки.ТолькоПросмотр = Не ЕстьПравоРедактирования;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Не ТекущийОбъект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = НавигационнаяСсылкаКартинки(ТекущийОбъект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	КонецЕсли;
	
	ПриСозданииНовогоПриЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.ВладелецФайла = Объект.Ссылка Тогда
		
		Модифицированность = Истина;
		СсылкаНаФайл = Параметр.Файл;
		
		Если ВыборИзображения Тогда
		
			Объект.ФайлКартинки = СсылкаНаФайл;
			АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор);
			НастроитьДоступностьРедактированияКартинки(ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("СменаВидаНоменклатурыОтработана");
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ЗначениеЗаполнено(ДанныеФайлаКартинки) Тогда
		
		СсылкаНового = ТекущийОбъект.ПолучитьСсылкуНового();
		Если СсылкаНового.Пустая() Тогда
			СсылкаНового = Справочники.Номенклатура.ПолучитьСсылку();
			ТекущийОбъект.УстановитьСсылкуНового(СсылкаНового);
		КонецЕсли;
		
		ПараметрыФайлаКартинки = Новый Структура();
		ПараметрыФайлаКартинки.Вставить("Автор", Пользователи.АвторизованныйПользователь());
		ПараметрыФайлаКартинки.Вставить("ВладелецФайлов", СсылкаНового);
		ПараметрыФайлаКартинки.Вставить("ИмяБезРасширения", ДанныеФайлаКартинки.ИмяБезРасширения);
		ПараметрыФайлаКартинки.Вставить("РасширениеБезТочки", ДанныеФайлаКартинки.Расширение);
		ПараметрыФайлаКартинки.Вставить("ВремяИзмененияУниверсальное", ДанныеФайлаКартинки.УниверсальноеВремяИзменения);
		
		ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайлаКартинки, АдресКартинки, "", "");
		
		ТекущийОбъект.ФайлКартинки = ПрисоединенныйФайл;
		
		ДанныеФайлаКартинки = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	НастроитьВозможностьДобавленияУпаковок();
	НастроитьДоступностьРедактированияКартинки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_Номенклатура", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПерейтиНоменклатураСАналогичнымиСвойствами(Команда)
	
	ГиперссылкаПерейтиСформироватьПараметрыИВопрос(Команда.Имя, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов(Команда)
	
	ПараметрыВыбораФайла = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе, РежимВыбора", Объект.Ссылка, Истина, Истина);
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьКартинкуИзПрисоединенныхФайловЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыВыбораФайла, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайловЗавершение(ЗначениеВыбора, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
		
		Объект.ФайлКартинки = ЗначениеВыбора;
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор);
		НастроитьДоступностьРедактированияКартинки(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображение(Команда)
	
	ЗаблокироватьДанныеФормыДляРедактирования();
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	
	Объект.ФайлКартинки = ПредопределенноеЗначение("Справочник.НоменклатураПрисоединенныеФайлы.ПустаяСсылка");
	АдресКартинки = "";
	ДанныеФайлаКартинки = Неопределено;
	НастроитьДоступностьРедактированияКартинки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьИзображение(Команда)
	
	ПросмотретьПрисоединенныйФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображение(Команда)
	
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		РаботаСФайламиКлиент.ОткрытьФормуФайла(Объект.ФайлКартинки);
	Иначе
		ТекстСообщения = НСтр("ru='Отсутствует изображение для редактирования'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ОбработатьИзменениеВидаНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	
	ОбработатьИзменениеБазовойЕдиницыИзмерения();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбработатьИзменениеНаименования();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Описание",  НСтр("ru = 'Дополнительная информация'"));
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНовогоПриЧтенииНаСервере()
	
	ПолучитьПараметрыЗаполненияПоВидуНоменклатуры();
	
	УстановитьВидимостьДоступностьНаСервере();
	
	НастроитьДоступностьРедактированияКартинки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	Элементы.Комплект.Видимость = Объект.Комплектуемая;	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПараметрыЗаполненияПоВидуНоменклатуры()
	
	ЗапрашиваемыеПоля = Новый Структура;
	ЗапрашиваемыеПоля.Вставить("ШаблонНаименованияДляПечатиНоменклатуры");
	ЗапрашиваемыеПоля.Вставить("ШаблонРабочегоНаименованияНоменклатуры");
	ЗапрашиваемыеПоля.Вставить("ЗапретРедактированияНаименованияДляПечатиНоменклатуры");
	ЗапрашиваемыеПоля.Вставить("ЗапретРедактированияРабочегоНаименованияНоменклатуры");
	ЗапрашиваемыеПоля.Вставить("ИспользоватьПартии");
	
	ПараметрыВидаНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидНоменклатуры, ЗапрашиваемыеПоля);
	
	ШаблонНаименованияДляПечати = ПараметрыВидаНоменклатуры.ШаблонНаименованияДляПечатиНоменклатуры;
	ШаблонРабочегоНаименования = ПараметрыВидаНоменклатуры.ШаблонРабочегоНаименованияНоменклатуры;
	ЗапретРедактированияНаименованияДляПечати = ПараметрыВидаНоменклатуры.ЗапретРедактированияНаименованияДляПечатиНоменклатуры;
	ЗапретРедактированияРабочегоНаименования = ПараметрыВидаНоменклатуры.ЗапретРедактированияРабочегоНаименованияНоменклатуры;
	
	Если ПараметрыВидаНоменклатуры.ИспользоватьПартии = Истина Тогда
		НастройкаИспользованияПартий = НСтр("ru = 'По документам оприходования'");
	Иначе
		НастройкаИспользованияПартий = НСтр("ru = 'Не используются'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьНаСервере()
	
	УстановитьВидимостьПоВидуНоменклатуры();	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПоВидуНоменклатуры()
	
	ЭтоУслуга = (Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга);
	
	ЗаполненВидНоменклатуры = ЗначениеЗаполнено(Объект.ВидНоменклатуры);
	
	Элементы.ВестиУчетПоГТД.Видимость = Не ЭтоУслуга;
	Элементы.НастройкаИспользованияСерий.Видимость = Не ЭтоУслуга;
	Элементы.НастройкаИспользованияПартий.Видимость = Не ЭтоУслуга;
	
	Если ЭтоУслуга Тогда
		ЗаголовокЕдиницыИзмерения = НСтр("ru = 'Единица измерения'");
	Иначе
		ЗаголовокЕдиницыИзмерения = НСтр("ru = 'Единица хранения'");
	КонецЕсли;
	Элементы.ЕдиницаИзмерения.Заголовок = ЗаголовокЕдиницыИзмерения;
			
	ПараметрыСерий = ЗначениеНастроекПоддержкаПроектовПовтИсп.ПараметрыСерийНоменклатуры(Объект.ВидНоменклатуры);
	
	НастройкаИспользованияСерий = Справочники.ВидыНоменклатуры.ПредставлениеНастройкиИспользованияСерий(ПараметрыСерий);
		
	Элементы.Наименование.ТолькоПросмотр = ЗаполненВидНоменклатуры И ЗапретРедактированияРабочегоНаименования;
	Элементы.НаименованиеПолное.ТолькоПросмотр = ЗаполненВидНоменклатуры И ЗапретРедактированияНаименованияДляПечати;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеВидаНоменклатуры()
	
	ИспользоватьНесколькоВидовНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовНоменклатуры");
	Если Не ИспользоватьНесколькоВидовНоменклатуры Тогда
		СписокВидов = Справочники.ВидыНоменклатуры.ПолучитьПредустановленныеВидыНоменклатуры();
		Элементы.ВидНоменклатурыПереключатель.СписокВыбора.ЗагрузитьЗначения(СписокВидов);
	КонецЕсли;
	
	Элементы.ВидНоменклатуры.Видимость = ИспользоватьНесколькоВидовНоменклатуры;
	Элементы.ТипНоменклатурыРасширенный.Видимость = ИспользоватьНесколькоВидовНоменклатуры;
	Элементы.ВидНоменклатурыПереключатель.Видимость = Не ИспользоватьНесколькоВидовНоменклатуры;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойствоЭлементовФормы(ЭлементыФормы, ИмяСвойства, ЗначенияСвойстваЭлементов)
	
	Для Каждого Значение Из ЗначенияСвойстваЭлементов Цикл
		
		Если ЭлементыФормы.Найти(Значение.Ключ) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементыФормы[Значение.Ключ][ИмяСвойства] = Значение.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка гиперссылок
#Область ОбработкаГиперссылок

&НаКлиенте
Процедура ГиперссылкаПерейтиСформироватьПараметрыИВопрос(ИмяГиперссылки, ПринудительнаяЗапись = Ложь)
	
	Если Объект.Ссылка.Пустая() Или ПринудительнаяЗапись Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Переход к дополнительной информации возможен только после записи элемента.
		|Записать элемент?'");
		
		Оповещение = Новый ОписаниеОповещения("ГиперссылкаПерейтиВопросЗавершение", ЭтотОбъект, ИмяГиперссылки);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ГиперссылкаПерейти(ИмяГиперссылки);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПерейтиВопросЗавершение(РезультатВопроса, ИмяГиперссылки) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ГиперссылкаПерейти(ИмяГиперссылки);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПерейти(ИмяГиперссылки)
	
	ПараметрыПереходаПоГиперссылке = ПараметрыПереходаПоГиперссылке(ИмяГиперссылки);
	
	ОткрытьФорму(
		ПараметрыПереходаПоГиперссылке.ИмяФормы,
		ПараметрыПереходаПоГиперссылке.ПараметрыФормы,
		,
		УникальныйИдентификатор,
		,
		,
		,
		РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыПереходаПоГиперссылке(ИмяЭлемента)
	
	Если ИмяЭлемента = "КомандаПерейтиНоменклатураСАналогичнымиСвойствами" Тогда
		
		ПараметрыФормы = Новый Структура("НоменклатураФильтраПоСвойствам", Объект.Ссылка);
		
		ПараметрыПереходаПоГиперссылке = Новый Структура;
		ПараметрыПереходаПоГиперссылке.Вставить("ИмяФормы", "Справочник.Номенклатура.ФормаСписка");
		ПараметрыПереходаПоГиперссылке.Вставить("ПараметрыФормы", ПараметрыФормы);
		
	КонецЕсли;
	
	Возврат ПараметрыПереходаПоГиперссылке;
	
КонецФункции

#КонецОбласти // ОбработкаГиперссылок

////////////////////////////////////////////////////////////////////////////////
// Обработка изменения реквизитов
#Область ОбработкаИзмененийРеквизитов

&НаКлиенте
Процедура ОбработатьИзменениеНаименования()

	Если ПустаяСтрока(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеБазовойЕдиницыИзмерения()
	
	Если ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
		ТипЕдиницы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ЕдиницаИзмерения, "ТипЕдиницы");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПоискПоТекстуЕдиницыИзмерения (Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(Текст) Тогда
		ДоступныеЕдиницы = Новый Массив;
		Для Каждого Элемент Из Элемент.СписокВыбора Цикл
			ДоступныеЕдиницы.Добавить(Элемент.Значение.Значение);
		КонецЦикла;
		
		ПараметрыПолученияДанных.Отбор.Вставить("Ссылка", ДоступныеЕдиницы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеВидаНоменклатуры()
	
	ОбновитьЭлементыДополнительныхРеквизитов();
	
	Справочники.Номенклатура.ЗаполнитьРеквизитыПоВидуНоменклатуры(Объект);
		
	ПолучитьПараметрыЗаполненияПоВидуНоменклатуры();
	Если ЗначениеЗаполнено(Объект.ВидНоменклатуры) Тогда
		
		Если ЗначениеЗаполнено(ШаблонРабочегоНаименования) Тогда
			Объект.Наименование = "";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ШаблонНаименованияДляПечати) Тогда
			Объект.НаименованиеПолное = "";
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьВидимостьПоВидуНоменклатуры();
		
КонецПроцедуры

&НаКлиенте
Процедура КомплектуемаяПриИзменении(Элемент)
	
	УстановитьУсловноеОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектНоменклатураПриИзменении(Элемент)
	Идентификатор = Элементы.Комплект.ТекущиеДанные.ПолучитьИдентификатор();
КонецПроцедуры

&НаСервере
Процедура УстановитьЕдиницуИзмерения(Идентификатор)
	Строка = Объект.Комплект.НайтиПоИдентификатору(Идентификатор);
	Строка.ЕдиницаИзмерения = Строка.Номенклатура.ЕдиницаИзмерения;
	Строка.Количество = ?(ЗначениеЗаполнено(Строка.Номенклатура), 1, 0);
КонецПроцедуры

#КонецОбласти // ОбработкаИзмененийРеквизитов

////////////////////////////////////////////////////////////////////////////////
// Присоединенные файлы
#Область ПрисоединенныеФайлы

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьДоступностьРедактированияКартинки(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.ИзменитьИзображение.Видимость = Не Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ФайлКартинки);
	Элементы.ПросмотретьИзображение.Видимость = Не Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ФайлКартинки);
	Элементы.ВыбратьКартинкуИзПрисоединенныхФайлов.Видимость = Не Объект.Ссылка.Пустая();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НавигационнаяСсылкаКартинки(Знач ФайлКартинки, Знач ИдентификаторФормы)
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если Объект.Ссылка.Пустая() Тогда
		
		//ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		//ДиалогВыбораФайла.Фильтр = ФильтрФайловИзображений();
		//
		//ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеФайлаДиалогЗавершение", ЭтотОбъект);
		//ДиалогВыбораФайла.Показать(ОписаниеОповещения);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо записать объект!");
		
	Иначе
		ВыборИзображения = Истина;
		ИдентификаторФайла = Новый УникальныйИдентификатор;
		РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла, ФильтрФайловИзображений());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеФайлаДиалогЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла = ВыбранныеФайлы[0];
	Файл = Новый Файл(ИмяФайла);
	ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
	ДополнительныеПараметры.Вставить("Файл", Файл);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДобавлениеФайлаПроверкаСуществования",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеФайлаПроверкаСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Файл не найден'"));
		Возврат;
	КонецЕсли;
	
	ДанныеФайлаКартинки =
		Новый Структура("ИмяБезРасширения, Расширение, УниверсальноеВремяИзменения");
	
	ЗаполнитьЗначенияСвойств(ДанныеФайлаКартинки, ДополнительныеПараметры.Файл);
	
	ДанныеФайлаКартинки.Расширение =
		СтрЗаменить(ДанныеФайлаКартинки.Расширение, ".", "");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДобавлениеФайлаПолучениеУниверсальногоВремениИзменения",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ДополнительныеПараметры.Файл.НачатьПолучениеУниверсальногоВремениИзменения(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеФайлаПолучениеУниверсальногоВремениИзменения(ВремяИзменения, ДополнительныеПараметры) Экспорт
	
	ДанныеФайлаКартинки.УниверсальноеВремяИзменения = ВремяИзменения;
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ДополнительныеПараметры.ИмяФайла);
	АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	
	АдресКартинки = АдресФайлаВХранилище;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл()
	
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(ЭтотОбъект.Объект.ФайлКартинки, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	Иначе
		ТекстСообщения = НСтр("ru='Отсутствует изображение для просмотра'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ФильтрФайловИзображений()
	Возврат НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf"
		                            + "|Все файлы(*.*)|*.*"
		                            + "|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle"
		                            + "|Формат GIF(*.gif*)|*.gif"
		                            + "|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg"
		                            + "|Формат PNG(*.png*)|*.png"
		                            + "|Формат TIFF(*.tif)|*.tif"
		                            + "|Формат icon(*.ico)|*.ico"
		                            + "|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
КонецФункции

&НаСервере
Процедура СкопироватьПрисоединенныйФайлКартинки(ФайлКартинки)
	
	ДанныеПрисоединенногоФайла = РаботаСФайлами.ДанныеФайла(ФайлКартинки);
	
	ДанныеФайлаКартинки = Новый Структура;
	ДанныеФайлаКартинки.Вставить("Расширение", ДанныеПрисоединенногоФайла.Расширение);
	ДанныеФайлаКартинки.Вставить("ИмяБезРасширения", СтрЗаменить(ДанныеПрисоединенногоФайла.ИмяФайла, "." + ДанныеПрисоединенногоФайла.Расширение, ""));
	ДанныеФайлаКартинки.Вставить("УниверсальноеВремяИзменения", ДанныеПрисоединенногоФайла.ДатаМодификацииУниверсальная);
	
	ДвоичныеДанныеФайла  = ПолучитьИзВременногоХранилища(ДанныеПрисоединенногоФайла.СсылкаНаДвоичныеДанныеФайла);
	
	Если Не ЗначениеЗаполнено(ДвоичныеДанныеФайла) Тогда
		ДанныеФайлаКартинки = Неопределено;
	КонецЕсли;
	
	АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, ЭтаФорма.УникальныйИдентификатор)
	
КонецПроцедуры

#КонецОбласти // ПрисоединенныеФайлы

////////////////////////////////////////////////////////////////////////////////
// Прочее
#Область Прочее

&НаСервере
Процедура ЗаполнитьСписокВыбораУпаковкамиНоменклатуры(СписокВыбора)
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораЕдиницамиНоменклатуры(СписокВыбора)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", Объект.ЕдиницаИзмерения);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	10                                   КАК Порядок,
	|	ЕдиницыИзмерения.Ссылка              КАК Ссылка,
	|	ЕдиницыИзмерения.ПометкаУдаления     КАК ПометкаУдаления,
	|	ЕдиницыИзмерения.Наименование        КАК Наименование,
	|	ЕдиницыИзмерения.НаименованиеПолное  КАК НаименованиеПолное,
	|	ЕдиницыИзмерения.Коэффициент         КАК Коэффициент
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Номенклатура = &Номенклатура
	|	И ЕдиницыИзмерения.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	30                                   КАК Порядок,
	|	ЕдиницыИзмерения.Ссылка              КАК Ссылка,
	|	ЕдиницыИзмерения.ПометкаУдаления     КАК ПометкаУдаления,
	|	ЕдиницыИзмерения.Наименование        КАК Наименование,
	|	ЕдиницыИзмерения.НаименованиеПолное  КАК НаименованиеПолное,
	|	ЕдиницыИзмерения.Коэффициент         КАК Коэффициент
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Ссылка = &ЕдиницаИзмерения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	Коэффициент Убыв,
	|	НаименованиеПолное УБЫВ
	|";
	
	СписокВыбора.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокВыбора.Добавить(Новый Структура("Значение, ПометкаУдаления, Предупреждение", Выборка.Ссылка, Выборка.ПометкаУдаления), Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // Прочее

&НаСервере
Процедура УстановитьДоступностьПотребительскойУпаковки()
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВозможностьДобавленияУпаковок()
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СТАНДАРТНЫЕ ПОДСИСТЕМЫ
#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовПоддержкаПроектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти // СтандартныеПодсистемы
