﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = НСтр("ru = 'Выбранные значения'");
	Иначе
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ТипПеречисления) <> Тип("Тип") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	МетаданныеПеречисления = Метаданные.НайтиПоТипу(Параметры.ТипПеречисления);
	
	Если Метаданные.НайтиПоТипу(Параметры.ТипПеречисления) = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Для Каждого ЗначениеПеречисления Из МетаданныеПеречисления.ЗначенияПеречисления Цикл
		
		ЭлементСписка = Список.Добавить();
		
		ЭлементСписка.Значение      = Перечисления[МетаданныеПеречисления.Имя][ЗначениеПеречисления.Имя];
		ЭлементСписка.Представление = ЗначениеПеречисления.Синоним;
		
		Если Параметры.СписокОтбор.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено Тогда
			
			ЭлементСписка.Пометка = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбранныеЗначения = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка Из Список Цикл
		Если ЭлементСписка.Пометка Тогда
			ВыбранныеЗначения.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(ВыбранныеЗначения);
	
КонецПроцедуры

#КонецОбласти
