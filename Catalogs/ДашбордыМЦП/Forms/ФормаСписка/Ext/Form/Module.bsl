﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	#Если НЕ МобильныйАвтономныйСервер Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	#Иначе
		УИДПользователяИБ = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
		Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ",
																Новый УникальныйИдентификатор(УИДПользователяИБ));
		УстановитьУсловноеОформлениеПоНаличиюОфлайнОтчета();
	#КонецЕсли
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", Пользователь);
	
	#Если НЕ МобильныйАвтономныйСервер Тогда
		// СтандартныеПодсистемы.ПодключаемыеКоманды
		СписокТипов = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(
			Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
		ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
		ПараметрыРазмещения.Источники = СписокТипов;
		ПараметрыРазмещения.КоманднаяПанель = Элементы.Список.КонтекстноеМеню;
		
		ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
		// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если Не МобильныйКлиент Тогда
		Элементы.Список.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	#Иначе
	Если ОсновнойСерверДоступен() = Ложь Тогда
		Элементы.Список.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	#Если МобильныйКлиент Тогда
	СтандартнаяОбработка = Ложь;
	Если ОсновнойСерверДоступен() = Ложь Тогда
		ОткрытьФорму("РегистрСведений.СнимкиОтчетов.Форма.ФормаПросмотраОтчетов",
			Новый Структура("Дашборд", ВыбраннаяСтрока));
	Иначе
		ОткрытьФорму("Отчет.МониторЦелевыхПоказателей.Форма.ФормаМониторЦелевыхПоказателей", Новый Структура("Дашборд",
			ВыбраннаяСтрока));
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	КартинкаПометкиНаУдаление = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
	
	Для Каждого Строка Из Строки Цикл
		СтрокаСписка = Строка.Значение.Данные;
		Если СтрокаСписка.ПометкаУдаления Тогда
			СтрокаСписка.Иконка = КартинкаПометкиНаУдаление;
		Иначе
			СтрокаСписка.Иконка = ПолучитьНавигационнуюСсылку(Строка.Ключ, "Иконка");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	#Если Не МобильныйКлиент Тогда
		ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
	#Иначе
		Если ОсновнойСерверДоступен() <> Ложь Тогда
			Выполнить("ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список)");
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	#Если НЕ МобильныйАвтономныйСервер Тогда
		ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	#Если Не МобильныйКлиент Тогда
		ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	#Иначе
		Если ОсновнойСерверДоступен() <> Ложь Тогда
			Выполнить("ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список)");
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоНаличиюОфлайнОтчета()

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЕстьОфлайнОтчет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНеАктивнойСтроки);

КонецПроцедуры

#КонецОбласти
