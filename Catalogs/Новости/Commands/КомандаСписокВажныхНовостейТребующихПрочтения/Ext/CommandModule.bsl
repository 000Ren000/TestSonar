﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Работает только если подсистема ИПП выключена из командного интерфейса:
// e1cib/command/Справочник.Новости.Команда.КомандаСписокВажныхНовостейТребующихПрочтения.

// Важно, что подсистема ИнтернетПоддержкаПользователей должна быть включена в командный интерфейс (хотя может быть и не видна).
// Иначе будет ошибка при вызове этой команды.
// При изменении наименования подсистемы ИнтернетПоддержкаПользователей, необходимо изменить ссылки и здесь.
// НЕ работает, если подсистема ИПП выключена из командного интерфейса.
// e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокВажныхНовостейТребующихПрочтения.

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ОбработкаНовостейКлиент.ОткрытьСписокВажныхНовостейТребующихПрочтения(
		ПараметрКоманды,
		ПараметрыВыполненияКоманды,
		"e1cib/command/Справочник.Новости.Команда.КомандаСписокВажныхНовостейТребующихПрочтения");

КонецПроцедуры

#КонецОбласти
