﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаЗаменитьДубли.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаменитьДубли(Команда)
	ЗаменитьДублиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗаменитьДублиНаСервере()
	Справочники.КлючиАналитикиУчетаНоменклатуры.ЗаменитьДублиКлючейАналитики();
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти