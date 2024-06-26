
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборКомиссии(Команда)
	
	ВзаимодействиеСПользователемКлиент.ОткрытьПодборЧленовКомиссии(Элементы.СоставКомиссии);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СоставКомиссииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьПодборЧленовКомиссии(
		Объект.СоставКомиссии, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставКомиссииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьНачалоРедактированияСоставаКомиссии(
		Объект.СоставКомиссии, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставКомиссииПослеУдаления(Элемент)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьУдалениеЧленаКомиссии(Объект.СоставКомиссии);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставКомиссииПредседательПриИзменении(Элемент)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьИзменениеПредседателяКомиссии(Объект.СоставКомиссии, Элемент.Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставКомиссииЧленКомиссииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействиеСПользователемКлиент.ОбработатьВыборЧленаКомиссии(
		Объект.СоставКомиссии, Элемент.Родитель, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы
