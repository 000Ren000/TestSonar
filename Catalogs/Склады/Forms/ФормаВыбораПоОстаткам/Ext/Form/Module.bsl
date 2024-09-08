﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ВыборВЗаказ;
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры().Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Получение массива складов, входящих в иерархию параметра "ГруппаСкладов"
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка КАК Ссылка,
	|	Склады.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.Ссылка В ИЕРАРХИИ(&ГруппаСкладов)
	|	И Склады.ЭтоГруппа = ЛОЖЬ
	|	И ВЫБОР
	|			КОГДА &ВыборВЗаказ = ИСТИНА
	|				ТОГДА Склады.ВыборГруппы <> ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.Запретить)
	|			ИНАЧЕ Склады.ВыборГруппы = ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных)
	|		КОНЕЦ");
	Запрос.УстановитьПараметр("ВыборВЗаказ", Параметры().ВыборВЗаказ);
	Запрос.УстановитьПараметр("ГруппаСкладов", Параметры().Склад);
	ТаблицаСкладов = Запрос.Выполнить().Выгрузить();
	МассивСкладов = ТаблицаСкладов.ВыгрузитьКолонку("Ссылка");
	
	// Получение структуры остатков по номенклатуре/характеристике, заданной в параметрах, и массиву складов.
	СтруктураОстатков = ПодборТоваровСервер.ОстаткиНоменклатуры(Параметры().Номенклатура, Параметры().Характеристика, МассивСкладов);
	
	// Заполнение таблицы значений
	СкладыДанные = РеквизитФормыВЗначение("Склады");
	Для Каждого СтруктураТекущихОстатков Из СтруктураОстатков.ТекущиеОстатки Цикл
		
		// Текущие остатки
		НоваяСтрока = СкладыДанные.Строки.Добавить();
		НоваяСтрока.Склад = СтруктураТекущихОстатков.Склад;
		НоваяСтрока.Описание = СтруктураТекущихОстатков.Склад;
		НоваяСтрока.Доступно = СтруктураТекущихОстатков.Свободно;
		НоваяСтрока.Период = ТекущаяДатаСеанса();
		НоваяСтрока.ПериодОписание = НСтр("ru = 'Сейчас'");
		НоваяСтрока.ПометкаУдаления = ТаблицаСкладов.Найти(НоваяСтрока.Склад, "Ссылка").ПометкаУдаления;
		
		// Планируемые остатки
		Если Параметры().ВыборВЗаказ Тогда
			
			Для Каждого СтруктураПланируемыхОстатков Из СтруктураОстатков.ПланируемыеОстатки Цикл
				Если СтруктураПланируемыхОстатков.Склад <> СтруктураТекущихОстатков.Склад Тогда
					Продолжить;
				КонецЕсли;
				НоваяСтрокаПлана = НоваяСтрока.Строки.Добавить();
				НоваяСтрокаПлана.Склад = СтруктураПланируемыхОстатков.Склад;
				НоваяСтрокаПлана.Описание = "";
				НоваяСтрокаПлана.Доступно = СтруктураПланируемыхОстатков.Доступно;
				НоваяСтрокаПлана.Период = СтруктураПланируемыхОстатков.Период;
				НоваяСтрокаПлана.ПериодОписание = Формат(СтруктураПланируемыхОстатков.Период, "ДЛФ=D");
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	ЗначениеВРеквизитФормы(СкладыДанные, "Склады");
	
	ТекущийСклад = Параметры().ТекущаяСтрока;
	ВыборВЗаказ  = Параметры().ВыборВЗаказ;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТекущийСклад) Тогда
		
		Для Каждого Строка Из Склады.ПолучитьЭлементы() Цикл
			Если Строка.Склад = ТекущийСклад Тогда
				Элементы.Склады.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПриВыбореЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПриВыбореЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ПриВыбореЗначения()
	
	ТекущаяСтрока = Элементы.Склады.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		Если ТекущаяСтрока.ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru='Выбранный элемент помечен на удаление
			|Продолжить?'");
			Ответ = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("ПриВыбореЗначенияЗавершение", ЭтотОбъект, Новый Структура("ТекущаяСтрока", ТекущаяСтрока)), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
            Возврат;
		КонецЕсли;
		
		ПриВыбореЗначенияФрагмент(ТекущаяСтрока);

		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
// 	РезультатВопроса - КодВозвратаДиалога
// 	ДополнительныеПараметры - Структура - содержит:
// 		* ТекущаяСтрока - ДанныеФормыСтруктура
&НаКлиенте
Процедура ПриВыбореЗначенияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ПриВыбореЗначенияФрагмент(ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореЗначенияФрагмент(Знач ТекущаяСтрока)
    
    Если ВыборВЗаказ Тогда
        ЗначениеВозврата = Новый Структура("Склад, ДатаОтгрузки", ТекущаяСтрока.Склад, ТекущаяСтрока.Период);
    Иначе
        ЗначениеВозврата = ТекущаяСтрока.Склад;
    КонецЕсли;
    
    ОповеститьОВыборе(ЗначениеВозврата);

КонецПроцедуры 

// Возвращаемое значение:
// 	ДанныеФормыСтруктура - содержит в том числе:
// 		* ВыборВЗаказ - Булево
// 		* ТекущаяСтрока - СправочникСсылка.Склады
// 		* Номенклатура - СправочникСсылка.Номенклатура
// 		* Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры
//
&НаСервере
Функция Параметры()
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#КонецОбласти
