﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Если Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора) Тогда
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацииВЕТИС", ОрганизацииВЕТИС, СтруктураБыстрогоОтбора, Ложь);
		ОрганизацияВЕТИС = СтруктураБыстрогоОтбора.ОрганизацияВЕТИС;
		ОрганизацииВЕТИСПредставление = СтруктураБыстрогоОтбора.ОрганизацииВЕТИСПредставление;
		ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект,"Отбор");
		ИнтеграцияВЕТИСКлиентСервер.УстановитьОтборОрганизацияПредприятиеВЕТИС(Список,               ОрганизацииВЕТИС,"Грузоотправитель,Грузополучатель");
	КонецЕсли;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписок_ВетеринарноСопроводительныйДокументВЕТИС" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиентСервер.НастроитьОтборПоОрганизацииВЕТИС(ЭтаФорма, ОрганизацииВЕТИС,"Грузоотправитель,Грузополучатель","Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"Грузоотправитель,Грузополучатель");
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиентСервер.НастроитьОтборПоОрганизацииВЕТИС(ЭтаФорма, ВыбранноеЗначение,"Грузоотправитель,Грузополучатель","Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиентСервер.НастроитьОтборПоОрганизацииВЕТИС(ЭтаФорма, ОрганизацииВЕТИС,"Грузоотправитель,Грузополучатель","Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"Грузоотправитель,Грузополучатель");
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"Грузоотправитель,Грузополучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияВЕТИСКлиентСервер.НастроитьОтборПоОрганизацииВЕТИС(ЭтаФорма, ВыбранноеЗначение,"Грузоотправитель,Грузополучатель","Отбор");
	
КонецПроцедуры
	
#КонецОбласти
	
&НаКлиенте
Процедура ОтборТипПриИзменении(Элемент)
	
	УстановитьОтборТип();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборСтатус();
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИзменитьВидПродукции" Тогда
		ОткрытьФормыВыбораВидаПродукции();
		Возврат;
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОчиститьИерархию" Тогда
		ОчиститьИерархию();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтборПоПродукции" Тогда
		ОчиститьВидПродукции();
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтборПоТипуПродукции" Тогда
		ОчиститьВидПродукцииПродукцию();
	КонецЕсли;
	
	ОбработатьИзменениеОтбораПопродукции();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ВидыПериодов = СтрРазделить("ДатаПроизводства,СрокГодности",",");
	
	Для каждого Строка Из Строки Цикл
		
		ДанныеСтроки = Строка.Значение.Данные;
		
		Для каждого ВидПериода Из ВидыПериодов Цикл
			Если ДанныеСтроки.Свойство(ВидПериода) Тогда
				
				ПредставлениеПериода = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПериодаВЕТИС(
					ДанныеСтроки[ВидПериода+"ТочностьЗаполнения"],
					ДанныеСтроки[ВидПериода+"НачалоПериода"],
					ДанныеСтроки[ВидПериода+"КонецПериода"],
					ДанныеСтроки[ВидПериода+"Строка"]);
					
				ДанныеСтроки[ВидПериода] = ПредставлениеПериода;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГрузополучательХозяйствующийСубъект.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГрузополучательПредприятие.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыВетеринарныхДокументовВЕТИС.Производственный;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не используется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборТип()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЭтаФорма.Список,
		"Тип",
		ЭтаФорма.Тип,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ЭтаФорма.Тип));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСтатус()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЭтаФорма.Список,
		"Статус",
		ЭтаФорма.Статус,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ЭтаФорма.Статус));
	
КонецПроцедуры

#Область ОтборПоПродукции

&НаКлиенте
Процедура ОбработатьИзменениеОтбораПопродукции()
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	
	УстановитьОтборПродукция();
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиИнформациюОВидеТипеПродукции(Форма)
	
	ЦветГиперссылки = Форма.ЦветГиперссылки;
	
	Если ЗначениеЗаполнено(Форма.ТипПродукции) Тогда
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			Строка(Форма.ТипПродукции),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ОтборПоТипуПродукции");
		ОписаниеПродукцииПодсказка = Строка(Форма.ТипПродукции);
		
		ОписаниеПродукции = Новый ФорматированнаяСтрока(СтрокаСсылка);
		
		Если ЗначениеЗаполнено(Форма.Продукция) Тогда
			СтрокаПродукция = Строка(Форма.Продукция);
			ДлиннаяСтрока = СтрДлина(СтрокаПродукция)>30;
			СтрокаСсылка = Новый ФорматированнаяСтрока(
					Лев(СтрокаПродукция,30),
					Новый Шрифт(,,,,Истина),
					ЦветГиперссылки,,
					"ОтборПоПродукции");
			ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " > ", СтрокаСсылка, ?(ДлиннаяСтрока,"...",""));
			ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаПродукция;
		КонецЕсли;
		Если ЗначениеЗаполнено(Форма.ВидПродукции) Тогда
			СтрокаВидПродукции = Строка(Форма.ВидПродукции);
			ДлиннаяСтрока = СтрДлина(СтрокаВидПродукции)>30;
			СтрокаСсылка = Новый ФорматированнаяСтрока(
					Лев(СтрокаВидПродукции,30),
					Новый Шрифт(,,,,Истина),
					ЦветГиперссылки,,
					"ОтборПоВидуПродукции");
			ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " > ", СтрокаСсылка, ?(ДлиннаяСтрока,"...",""), " ");
			ОписаниеПродукцииПодсказка = ОписаниеПродукцииПодсказка + " > " + СтрокаВидПродукции;
		КонецЕсли;
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			НСтр("ru='изменить'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ИзменитьВидПродукции");
		ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, " ", "(", СтрокаСсылка, " ", НСтр("ru='или'"), " ");
		
		СтрокаСсылка = Новый ФорматированнаяСтрока(
			НСтр("ru='очистить'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ОчиститьИерархию");
		Форма.ОписаниеПродукции = Новый ФорматированнаяСтрока(ОписаниеПродукции, СтрокаСсылка, ")");
	Иначе
		
		Форма.ОписаниеПродукции = Новый ФорматированнаяСтрока(
			НСтр("ru='Выбрать группу продукции'"),
			Новый Шрифт(,,,,Истина),
			ЦветГиперссылки,,
			"ИзменитьВидПродукции");
		
	КонецЕсли;
	
	Форма.Элементы.ОписаниеПродукции.Подсказка = ОписаниеПродукцииПодсказка;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормыВыбораВидаПродукции()
	ОткрытьФорму("Обработка.КлассификаторыВЕТИС.Форма.КлассификаторИерархииПродукции",,ЭтаФорма,,,,
		Новый ОписаниеОповещения("КлассификаторПродукцииПриЗавершенииВыбора",ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторПродукцииПриЗавершенииВыбора(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ПолучитьИерархиюПродукции(Результат);
	КонецЕсли;
	УстановитьОтборПродукция();
КонецПроцедуры

&НаСервере
Процедура ПолучитьИерархиюПродукции(ВыбраннаяПродукция)
	
	Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВыбраннаяПродукция, "ТипПродукции, Продукция");
	Если ЗначениеЗаполнено(Результат.Продукция) Тогда
		ВидПродукции = ВыбраннаяПродукция;
		Продукция    = Результат.Продукция;
		ТипПродукции = Результат.ТипПродукции;
	ИначеЕсли ЗначениеЗаполнено(Результат.ТипПродукции) Тогда
		ВидПродукции = Неопределено;
		Продукция    = ВыбраннаяПродукция;
		ТипПродукции = Результат.ТипПродукции;
	Иначе
		ВидПродукции = Неопределено;
		Продукция    = Неопределено;
		ТипПродукции = ВыбраннаяПродукция;
	КонецЕсли;
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИерархию()
	
	ВидПродукции     = Неопределено;
	Продукция        = Неопределено;
	ТипПродукции     = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВидПродукции()
	
	ВидПродукции     = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВидПродукцииПродукцию()
	
	ВидПродукции     = Неопределено;
	Продукция        = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПродукция()
	
	ПродукцияОтбор = Неопределено;
	
	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		ПродукцияОтбор = ВидПродукции;
	ИначеЕсли ЗначениеЗаполнено(Продукция) Тогда
		ПродукцияОтбор = Продукция;
	ИначеЕсли ЗначениеЗаполнено(ТипПродукции) Тогда
		ПродукцияОтбор = ТипПродукции;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЭтаФорма.Список,
		"Продукция",
		ПродукцияОтбор,
		ВидСравненияКомпоновкиДанных.ВИерархии,,
		ЗначениеЗаполнено(ПродукцияОтбор));
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗапроситьВСДПоИдентификатору(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	
	ОрганизацииВЕТИСДляОбмена = ИнтеграцияВЕТИСКлиент.ОрганизацииВЕТИСДляОбмена(ЭтотОбъект);
	Если ОрганизацииВЕТИСДляОбмена <> Неопределено 
		И ОрганизацииВЕТИСДляОбмена.Количество() = 1 Тогда
		
		ОрганизацияВЕТИСДляОбмена = ОрганизацииВЕТИСДляОбмена[0];
		ПараметрыОткрытия.Вставить("ХозяйствующийСубъект", ОрганизацияВЕТИСДляОбмена.Организация);
		
		Если ОрганизацияВЕТИСДляОбмена.Предприятия.Количество() = 1 Тогда
			ПараметрыОткрытия.Вставить("Предприятие", ОрганизацияВЕТИСДляОбмена.Предприятия[0]);
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ЗапросВСД",
		ПараметрыОткрытия,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Аннулировать(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВСД", Элементы.Список.ВыделенныеСтроки);
	
	ОткрытьФорму("Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.Аннулирование",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
