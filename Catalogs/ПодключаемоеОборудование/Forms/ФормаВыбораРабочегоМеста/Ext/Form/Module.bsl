﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
	
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	
	Если Не ПустаяСтрока(ИдентификаторКлиента) Тогда
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Код", ИдентификаторКлиента));
		НовыйФиксированныйМассив = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.РабочееМесто.ПараметрыВыбора = НовыйФиксированныйМассив;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененоРабочееМестоТекущегоСеанса" Тогда
		РабочееМесто = МенеджерОборудованияКлиент.РабочееМестоКлиента();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИЗакрыть(Команда)
	
	ОчиститьСообщения();
		
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		Параметры.РабочееМесто = РабочееМесто;
		ОчиститьСообщения();
		СтруктураВозврата = Новый Структура("РабочееМесто", РабочееМесто);
		Закрыть(СтруктураВозврата);
	Иначе
		
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(НСтр("ru='Выберите рабочее место'"), РабочееМесто, "РабочееМесто");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти