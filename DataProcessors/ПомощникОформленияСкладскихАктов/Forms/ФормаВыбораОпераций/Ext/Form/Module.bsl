﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Строка = ТаблицаОпераций.Добавить();
	Строка.Операция = "Списание";
	Строка = ТаблицаОпераций.Добавить();
	Строка.Операция = "Оприходование";
	Строка = ТаблицаОпераций.Добавить();
	Строка.Операция = "Порча";
	Строка = ТаблицаОпераций.Добавить();
	Строка.Операция = "Пересортица";
	
	Если Параметры.Свойство("ВыбранныеОперации") Тогда
		КоличествоЭлементов = Параметры.ВыбранныеОперации.Количество();
		Если КоличествоЭлементов = 0 ИЛИ КоличествоЭлементов = ТаблицаОпераций.Количество() Тогда
			Для Каждого Строка Из ТаблицаОпераций Цикл
				Строка.Выбрана = Истина;
			КонецЦикла;
		Иначе
			Для Каждого Элемент Из Параметры.ВыбранныеОперации Цикл
				МассивСтрок = ТаблицаОпераций.НайтиСтроки(Новый Структура("Операция",Элемент));
				МассивСтрок[0].Выбрана = Истина;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отфильтровать(Команда)
	Результат = Новый Массив;
	Для Каждого Строка Из ТаблицаОпераций Цикл
		Если Строка.Выбрана Тогда
			Результат.Добавить(Строка.Операция);
		КонецЕсли;
	КонецЦикла;
	Если Результат.Количество() = ТаблицаОпераций.Количество() Тогда
		Результат.Очистить();
	КонецЕсли;
		
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)
	Для Каждого Строка Из ТаблицаОпераций Цикл
		Строка.Выбрана = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Установка условного оформления для поля 'Операция' табличной части.
	Обработки.ПомощникОформленияСкладскихАктов.УстановитьУсловноеОформлениеОперацияТекст(ЭтаФорма,
																						"ТаблицаОперацийОперация",
																						"ТаблицаОпераций.Операция");
	
КонецПроцедуры

#КонецОбласти