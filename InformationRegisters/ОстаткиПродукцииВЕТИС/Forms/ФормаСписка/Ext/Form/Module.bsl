﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИсключитьПросроченные = Параметры.ИсключитьПросроченные;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Если Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора) Тогда
		
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацииВЕТИС", ОрганизацииВЕТИС, СтруктураБыстрогоОтбора, Ложь);
		
		ОрганизацияВЕТИС = СтруктураБыстрогоОтбора.ОрганизацияВЕТИС;
		
		ОрганизацииВЕТИСПредставление = СтруктураБыстрогоОтбора.ОрганизацииВЕТИСПредставление;
		
		ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
		
		ИнтеграцияВЕТИСКлиентСервер.ОрганизацияВЕТИСОтборПриИзменении(ЭтотОбъект, "");
		
	ИначеЕсли Параметры.Отбор.Свойство("ХозяйствующийСубъект") 
		ИЛИ Параметры.Отбор.Свойство("Предприятие") Тогда
		
		Элементы.СтраницыОтборОрганизацияВЕТИС.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Параметры.ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные = Параметры.ТекущиеДанные;
		ЗаполнитьПараметрыДинамическогоСписка(ТекущиеДанные);
		Элементы.ОписаниеПродукции.Видимость = Ложь;
		Элементы.ОтборСтрок.Видимость = Истина;
		ОтборСтрок = "Рекомендуемые";
	Иначе 
		Элементы.ОтборСтрок.Видимость = Ложь;
		Элементы.ОписаниеПродукции.Видимость = Истина;
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
	
	Элементы.ФормаВыбрать.Видимость = РежимВыбора;

	ЗначениеПараметраКомпоновкиДанных = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СрокГодности"));
	ЗначениеПараметраКомпоновкиДанных.Значение = ТекущаяДатаСеанса();
	ЗначениеПараметраКомпоновкиДанных.Использование = ИсключитьПросроченные;
	
	Если ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Документы.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС) Тогда

		Элементы.ФормаОбъединитьЗаписиЖурнала.Видимость = НЕ РежимВыбора;
		Элементы.СписокКонтекстноеМенюОбъединитьЗаписиЖурнала.Видимость = НЕ РежимВыбора;
	Иначе
		Элементы.ФормаОбъединитьЗаписиЖурнала.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюОбъединитьЗаписиЖурнала.Видимость = Ложь;
	КонецЕсли;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборПродукция();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписок_ОстаткиПродукцииВЕТИС" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОтборИсключитьПросроченныеПриИзменении(Элемент)
	
	ЗначениеПараметраКомпоновкиДанных = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СрокГодности"));
	ЗначениеПараметраКомпоновкиДанных.Использование = ИсключитьПросроченные;
	
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

&НаКлиенте
Процедура ОтборПроизводительПриИзменении(Элемент)
	ОтборПроизводительПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтборМаркировкаПриИзменении(Элемент)
	ОтборМаркировкаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтрокПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Рекомендуемые", ОтборСтрок = "Рекомендуемые", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	МассивЗаписей = Новый Массив;
	Представления = Новый Соответствие;
	ВидыПериодов = СтрРазделить("ДатаПроизводства,СрокГодности",",");
	
	Для каждого Строка Из Строки Цикл
		
		ДанныеСтроки = Строка.Значение.Данные;
		ОформлениеСтроки = Строка.Значение.Оформление;
		
		Для каждого ВидПериода Из ВидыПериодов Цикл
			Если ДанныеСтроки.Свойство(ВидПериода) Тогда
				
				ПредставлениеПериода = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПериодаВЕТИС(
					ДанныеСтроки[ВидПериода+"ТочностьЗаполнения"],
					ДанныеСтроки[ВидПериода+"НачалоПериода"],
					ДанныеСтроки[ВидПериода+"КонецПериода"],
					ДанныеСтроки[ВидПериода+"Строка"]);
					
				ОформлениеСтроки[ВидПериода].УстановитьЗначениеПараметра("Текст", ПредставлениеПериода);
				
			КонецЕсли;
		КонецЦикла;
		
		МассивЗаписей.Добавить(ДанныеСтроки["ЗаписьСкладскогоЖурнала"]);
		Представления.Вставить(ДанныеСтроки["ЗаписьСкладскогоЖурнала"], Новый Структура("Производитель, Маркировка"));
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаписьСкладскогоЖурналаПроизводители.Ссылка КАК Ссылка,
	|	ЗаписьСкладскогоЖурналаПроизводители.Производитель КАК Производитель,
	|	ПроизводителиНомера.Номер КАК Маркировка
	|ПОМЕСТИТЬ ВтПроизводителиОбщая
	|ИЗ
	|	Справочник.ЗаписиСкладскогоЖурналаВЕТИС.Производители КАК ЗаписьСкладскогоЖурналаПроизводители
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредприятияВЕТИС.НомераПредприятий КАК ПроизводителиНомера
	|		ПО ЗаписьСкладскогоЖурналаПроизводители.Производитель = ПроизводителиНомера.Ссылка
	|ГДЕ
	|	ЗаписьСкладскогоЖурналаПроизводители.Ссылка В (&Записи)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Запись.Ссылка КАК Ссылка,
	|	ВтПроизводителиОбщая.Производитель КАК Производитель,
	|	ПРЕДСТАВЛЕНИЕ(ВтПроизводителиОбщая.Производитель) КАК ПроизводительПредставление
	|ИЗ
	|	Справочник.ЗаписиСкладскогоЖурналаВЕТИС КАК Запись
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтПроизводителиОбщая КАК ВтПроизводителиОбщая
	|		ПО ВтПроизводителиОбщая.Ссылка = Запись.Ссылка
	|ГДЕ
	|	Запись.Ссылка В (&Записи)
	|ИТОГИ
	|	КОЛИЧЕСТВО(Производитель)
	|ПО
	|	Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Запись.Ссылка КАК Ссылка,
	|	ВтПроизводителиОбщая.Маркировка КАК Маркировка
	|ИЗ
	|	Справочник.ЗаписиСкладскогоЖурналаВЕТИС КАК Запись
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтПроизводителиОбщая КАК ВтПроизводителиОбщая
	|		ПО ВтПроизводителиОбщая.Ссылка = Запись.Ссылка
	|		И НЕ(ВтПроизводителиОбщая.Маркировка ЕСТЬ NULL)
	|ГДЕ
	|	Запись.Ссылка В (&Записи)
	|ИТОГИ
	|	КОЛИЧЕСТВО(Маркировка)
	|ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("Записи", МассивЗаписей);
	
	Пакет = Запрос.ВыполнитьПакет();
	
	Выборка = Пакет[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		СтрокаСписка = Представления.Получить(Выборка.Ссылка);
		ДетальныеЗаписи = Выборка.Выбрать();
		Если Выборка.Производитель = 1 Тогда
			ДетальныеЗаписи.Следующий();
			СтрокаСписка.Производитель = СокрЛП(ДетальныеЗаписи.ПроизводительПредставление);
		ИначеЕсли Выборка.Производитель > 1 Тогда
			ОписаниеПроизводителей = Новый Массив;
			Пока ДетальныеЗаписи.Следующий() Цикл
				ОписаниеПроизводителей.Добавить(СокрЛП(ДетальныеЗаписи.ПроизводительПредставление));
			КонецЦикла;
			ПредставлениеПроизводителей = СтрСоединить(ОписаниеПроизводителей, "; ");
			Если СтрДлина(ПредставлениеПроизводителей) > 75 Тогда
				ПредставлениеПроизводителей = СтрШаблон("(%1) %2", Выборка.Производитель, ПредставлениеПроизводителей);
				ПредставлениеПроизводителей = Лев(ПредставлениеПроизводителей, 72) + "...";
			КонецЕсли;
			СтрокаСписка.Производитель = ПредставлениеПроизводителей;
		КонецЕсли;
		Представления.Вставить(Выборка.Ссылка, СтрокаСписка);
	КонецЦикла;
	
	Выборка = Пакет[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		СтрокаСписка = Представления.Получить(Выборка.Ссылка);
		ДетальныеЗаписи = Выборка.Выбрать();
		Если Выборка.Маркировка = 1 Тогда
			ДетальныеЗаписи.Следующий();
			СтрокаСписка.Маркировка = СокрЛП(ДетальныеЗаписи.Маркировка);
		ИначеЕсли Выборка.Маркировка > 1 Тогда
			ВозможнаяМаркировка = Новый Массив;
			Пока ДетальныеЗаписи.Следующий() Цикл
				ВозможнаяМаркировка.Добавить(СокрЛП(ДетальныеЗаписи.Маркировка));
			КонецЦикла;
			Маркировка = СтрСоединить(ВозможнаяМаркировка, "; ");
			Если СтрДлина(Маркировка) > 75 Тогда
				Маркировка = СтрШаблон("(%1) %2", Выборка.Маркировка, Маркировка);
				Маркировка = Лев(Маркировка, 72) + "...";
			КонецЕсли;
			СтрокаСписка.Маркировка = Маркировка;
		КонецЕсли;
		Представления.Вставить(Выборка.Ссылка, СтрокаСписка);
	КонецЦикла;
	
	Для каждого Строка Из Строки Цикл
		
		ДанныеСтроки = Строка.Значение.Данные;
		ДанныеСтроки["Производитель"] = Представления.Получить(ДанныеСтроки["ЗаписьСкладскогоЖурнала"]).Производитель;
		ДанныеСтроки["Маркировка"] = Представления.Получить(ДанныеСтроки["ЗаписьСкладскогоЖурнала"]).Маркировка;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборЗаписиЖурнала();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ОбработатьВыборЗаписиЖурнала();
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьЗаписиЖурнала(Команда)
	
	ВыбранныеЗаписи = ВыбранныеЗаписиСкладскогоЖурнала();
	
	Если ВыбранныеЗаписи.Количество() > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", ВыбранныеЗаписи);
		ОткрытьФорму("Документ.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.ФормаОбъекта", ПараметрыФормы);
		
	Иначе
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВетеринарныеМероприятия(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ЗаписьСкладскогоЖурнала", ТекущиеДанные.ЗаписьСкладскогоЖурнала);
	
	ОткрытьФорму(
		"Справочник.ЗаписиСкладскогоЖурналаВЕТИС.Форма.ВетеринарныеМероприятия",
		ПараметрыОткрытияФормы,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборЗаписиЖурнала()

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		РезультатВыбора = ИнтеграцияВЕТИСКлиент.РезультатВыбораЗаписиЖурнала();
		ЗаполнитьЗначенияСвойств(РезультатВыбора, ТекущиеДанные);
		ОповеститьОВыборе(РезультатВыбора);
		
	Иначе
		
		ПоказатьЗначение(,ТекущиеДанные.ЗаписьСкладскогоЖурнала);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОтборПроизводительПриИзмененииНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ЗаписьСкладскогоЖурнала.Производители.Производитель",
		ОтборПроизводитель,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПроизводитель));
	
КонецПроцедуры

&НаСервере
Процедура ОтборМаркировкаПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(ОтборМаркировка) Тогда 
		
		ЗапросПроизводители = Новый Запрос;
		ЗапросПроизводители.Текст = 
		"ВЫБРАТЬ
		|	НомераПредприятий.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПредприятияВЕТИС.НомераПредприятий КАК НомераПредприятий
		|ГДЕ
		|	НомераПредприятий.Номер = &ОтборМаркировка";
		ЗапросПроизводители.УстановитьПараметр("ОтборМаркировка", ОтборМаркировка);
		Выборка = ЗапросПроизводители.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			ОтборПроизводитель = Выборка.Ссылка;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"ЗаписьСкладскогоЖурнала.Производители.Производитель",
			ОтборПроизводитель,
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(ОтборПроизводитель));
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыбранныеЗаписиСкладскогоЖурнала()

	ВыбранныеЗаписи = Новый Массив;
	
	Для каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		Если ТипЗнч(СтрокаСписка) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ВыбранныеЗаписи.Добавить(СтрокаСписка.ЗаписьСкладскогоЖурнала);
		КонецЕсли;
	КонецЦикла;

	Возврат ВыбранныеЗаписи;
	
КонецФункции
 
#Область ОтборПоПродукции

&НаСервере
Процедура ЗаполнитьПараметрыДинамическогоСписка(ТекущиеДанные)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Номенклатура", ТекущиеДанные.Номенклатура, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Характеристика", ТекущиеДанные.Характеристика, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Серия", ТекущиеДанные.Серия, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Продукция", ТекущиеДанные.Продукция, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаполненаНоменклатура", ЗначениеЗаполнено(ТекущиеДанные.Номенклатура), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаполненаПродукция", ЗначениеЗаполнено(ТекущиеДанные.Продукция), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаполненаСерия", ЗначениеЗаполнено(ТекущиеДанные.Серия), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустаяСерия", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("СерияНоменклатурыВЕТИС"), Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Рекомендуемые", Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеОтбораПопродукции()
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтотОбъект);
	
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
	ОткрытьФорму("Обработка.КлассификаторыВЕТИС.Форма.КлассификаторИерархииПродукции",,ЭтотОбъект,,,,
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
	
	ВывестиИнформациюОВидеТипеПродукции(ЭтотОбъект);
	
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
		Список,
		"Продукция",
		ПродукцияОтбор,
		ВидСравненияКомпоновкиДанных.ВИерархии,,
		ЗначениеЗаполнено(ПродукцияОтбор));
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти