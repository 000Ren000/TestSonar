﻿#Область ОбработчикиСобытий

// Обработчик команды
//
// Параметры:
//   ПараметрКоманды - Произвольный
//   ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды:
//     * Источник - ФормаКлиентскогоПриложения:
//         ** Наименование - Строка
//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если Найти(ПараметрыВыполненияКоманды.Источник.ИмяФормы,"БизнесПроцесс") <> 0 Тогда
			ВнешнийОбъект = Новый Структура;
			ВнешнийОбъект.Вставить("name", ПараметрыВыполненияКоманды.Источник.Наименование);
			ВнешнийОбъект.Вставить("ID", ПараметрыВыполненияКоманды.Источник.ID);
			ВнешнийОбъект.Вставить("type", ПараметрыВыполненияКоманды.Источник.Тип);
			ВнешнийОбъект.Вставить("presentation", ПараметрыВыполненияКоманды.Источник.Представление);
			ПараметрыФормы = Новый Структура("ВнешнийОбъект",ВнешнийОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ИнтеграцияС1СДокументооборот.Форма.ВсеЗадачи",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти